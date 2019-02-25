import math

from migen import *
from migen.build.generic_platform import *
from migen.build.xilinx import XilinxPlatform, VivadoProgrammer

_io = [
    ("clk100", 0, Pins("H4"), IOStandard("LVCMOS33")),
    ("serial", 0,
        Subsignal("tx", Pins("Y21")),
        Subsignal("rx", Pins("Y22")),
        IOStandard("LVCMOS33"),
    ),
]


class Platform(XilinxPlatform):
    name = "mimas_a7"
    default_clk_name = "clk100"
    default_clk_period = 10.0

    def __init__(self, toolchain="vivado", programmer="vivado"):
        XilinxPlatform.__init__(self, "xc7a50t-fgg484-1", _io, [], toolchain=toolchain)
        self.toolchain.bitstream_commands = \
            ["set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]"]
        self.toolchain.additional_commands = \
            ["write_cfgmem -force -format bin -interface spix4 -size 16 "
             "-loadbit \"up 0x0 {build_name}.bit\" -file {build_name}.bin"]
        self.programmer = programmer
        self.add_platform_command("set_property INTERNAL_VREF 0.750 [get_iobanks 34]")

    def create_programmer(self):
        if self.programmer == "vivado":
            return VivadoProgrammer(flash_part="n25q128-3.3v-spi-x1_x2_x4")
        else:
            raise ValueError("{} programmer is not supported"
                             .format(self.programmer))


class UartTop(Module):
    def __init__(self, platform, clk_freq=100000000):
        self.data_in = data_in = Signal(8)
        self.text = text = "Hello World!\n\r"
        self.data = data = Array(Signal(8) for a in range(len(text)))
        self.timer = timer = Signal(max=int(clk_freq))
        self.run = run = Signal()
        self.data_valid = data_valid = Signal()
        self.address = address = Signal(math.ceil(math.log2(len(text))))
        self.tx_done = tx_done = Signal()
        serial = platform.request("serial")

        self.comb += [
            data[i].eq(ord(text[i])) for i in range(len(text))
        ]

        self.sync += [
            timer.eq(timer + 1),
            If(timer == int(clk_freq-1), run.eq(1), timer.eq(0)
               )
        ]
        self.sync += [
            If(run,
                If(address == 0,
                    data_valid.eq(1),
                    data_in.eq(data[0]),
                    address.eq(1),
                ).Elif(tx_done,
                    data_valid.eq(1),
                    data_in.eq(data[address]),
                    address.eq(address + 1),
                ).Else(
                    data_valid.eq(0)
               ),
               If(address == len(text),
                    address.eq(0),
                    run.eq(0)
                  )
            ).Else(
                data_valid.eq(0)
            )
        ]

        self.uart = uart = UartTx()
        self.submodules += uart
        self.comb += [
            uart.data_valid.eq(data_valid),
            tx_done.eq(uart.tx_done),
            uart.din.eq(data_in),
            serial.tx.eq(uart.tx)
        ]


class UartTx(Module):
    def __init__(self, clk_bit=868):
        self.cnt = Signal(32)
        self.i = Signal(4)
        self.din = din = Signal(8)
        self.d = d = Signal(8)
        self.tx = tx = Signal()
        self.tx_done = tx_done = Signal()
        self.data_valid = data_valid = Signal()

        self.fsm = FSM()
        self.submodules += self.fsm

        self.fsm.act("idle",
            tx.eq(1),
            NextValue(tx_done, (0)),
            If(data_valid,
                NextValue(self.d, (din)),
                NextState("tx_start")
            ).Else(
                NextState("idle")

            )
        )

        self.fsm.act("tx_start",
            tx.eq(0),
            If(self.cnt < clk_bit,
                NextValue(self.cnt, (self.cnt + 1)),
                NextState("tx_start")
            ).Else(
                NextState("tx_data"),
                NextValue(self.cnt, (0))
            )
        )

        self.fsm.act("tx_data",
            tx.eq(d[0]),
            If(self.i == 0,
                NextValue(self.i, (self.i + 1)),
            ).Else(
                If(self.cnt < clk_bit,
                    NextValue(self.cnt, (self.cnt + 1)),
                    NextState("tx_data")
                ).Else(
                    If(self.i < 8,
                        NextValue(d, (d >> 1)),
                        NextValue(self.i, (self.i + 1)),
                        NextValue(self.cnt, (0)),
                        NextState("tx_data")
                    ).Else(
                        NextState("tx_stop"),
                        NextValue(self.cnt, (0)),
                        NextValue(self.i, (0))
                    )
                )
            )
        )

        self.fsm.act("tx_stop",
            tx.eq(1),
            If(self.cnt < clk_bit,
                NextValue(self.cnt, (self.cnt + 1)),
                NextState("tx_stop")
            ).Else(
                NextState("idle"),
                NextValue(tx_done, (1)),
                NextValue(self.cnt, (0))
            )
        )


platform = Platform()
dut = UartTop(platform)
platform.build(dut, build_name="mimasa7_uart")




