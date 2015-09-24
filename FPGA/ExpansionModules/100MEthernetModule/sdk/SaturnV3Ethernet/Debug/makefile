################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include src/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
ELFSIZE += \
SaturnV3Ethernet.elf.size \

ELFCHECK += \
SaturnV3Ethernet.elf.elfcheck \


# All Target
all: SaturnV3Ethernet.elf secondary-outputs

# Tool invocations
SaturnV3Ethernet.elf: $(OBJS) ../src/lscript.ld $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: MicroBlaze gcc linker'
	mb-gcc -Wl,-T -Wl,../src/lscript.ld -L../../SaturnV3Ethernet_bsp/microblaze_0/lib -mlittle-endian -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.50.c -mno-xl-soft-mul -Wl,--no-relax -Wl,--gc-sections -o "SaturnV3Ethernet.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

SaturnV3Ethernet.elf.size: SaturnV3Ethernet.elf
	@echo 'Invoking: MicroBlaze Print Size'
	mb-size SaturnV3Ethernet.elf  |tee "SaturnV3Ethernet.elf.size"
	@echo 'Finished building: $@'
	@echo ' '

SaturnV3Ethernet.elf.elfcheck: SaturnV3Ethernet.elf
	@echo 'Invoking: Xilinx ELF Check'
	elfcheck SaturnV3Ethernet.elf -hw ../../SaturnV3Ethernet100M_hw_platform/system.xml -pe microblaze_0  |tee "SaturnV3Ethernet.elf.elfcheck"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(OBJS)$(C_DEPS)$(EXECUTABLES)$(ELFSIZE)$(ELFCHECK)$(S_UPPER_DEPS) SaturnV3Ethernet.elf
	-@echo ' '

secondary-outputs: $(ELFSIZE) $(ELFCHECK)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
