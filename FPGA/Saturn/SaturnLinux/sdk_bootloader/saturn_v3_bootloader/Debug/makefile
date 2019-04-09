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
saturn_v3_bootloader.elf.size \

ELFCHECK += \
saturn_v3_bootloader.elf.elfcheck \


# All Target
all: saturn_v3_bootloader.elf secondary-outputs

# Tool invocations
saturn_v3_bootloader.elf: $(OBJS) ../src/lscript.ld $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: MicroBlaze gcc linker'
	mb-gcc -Wl,-T -Wl,../src/lscript.ld -L../../saturn_v3_bootloader_bsp/microblaze_0/lib -mlittle-endian -mxl-barrel-shift -mxl-pattern-compare -mno-xl-soft-div -mcpu=v8.50.c -mno-xl-soft-mul -mxl-multiply-high -Wl,--no-relax -Wl,--gc-sections -o "saturn_v3_bootloader.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

saturn_v3_bootloader.elf.size: saturn_v3_bootloader.elf
	@echo 'Invoking: MicroBlaze Print Size'
	mb-size saturn_v3_bootloader.elf  |tee "saturn_v3_bootloader.elf.size"
	@echo 'Finished building: $@'
	@echo ' '

saturn_v3_bootloader.elf.elfcheck: saturn_v3_bootloader.elf
	@echo 'Invoking: Xilinx ELF Check'
	elfcheck saturn_v3_bootloader.elf -hw ../../xps_hw_platform/system.xml -pe microblaze_0  |tee "saturn_v3_bootloader.elf.elfcheck"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(OBJS)$(C_DEPS)$(EXECUTABLES)$(ELFSIZE)$(ELFCHECK)$(S_UPPER_DEPS) saturn_v3_bootloader.elf
	-@echo ' '

secondary-outputs: $(ELFSIZE) $(ELFCHECK)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
