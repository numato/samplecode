open_project -project {D:\Gayathri\polarfire_soc\iciclekit_yoshi-vga_wrking\iciclekit_yoshi-vga\designer\display_top\display_top_fp\display_top.pro}\
         -connect_programmers {FALSE}
load_programming_data \
    -name {MPFS250T_ES} \
    -fpga {D:\Gayathri\polarfire_soc\iciclekit_yoshi-vga_wrking\iciclekit_yoshi-vga\designer\display_top\display_top.map} \
    -header {D:\Gayathri\polarfire_soc\iciclekit_yoshi-vga_wrking\iciclekit_yoshi-vga\designer\display_top\display_top.hdr} \
    -snvm {D:\Gayathri\polarfire_soc\iciclekit_yoshi-vga_wrking\iciclekit_yoshi-vga\designer\display_top\display_top_snvm.efc} \
    -spm {D:\Gayathri\polarfire_soc\iciclekit_yoshi-vga_wrking\iciclekit_yoshi-vga\designer\display_top\display_top.spm} \
    -dca {D:\Gayathri\polarfire_soc\iciclekit_yoshi-vga_wrking\iciclekit_yoshi-vga\designer\display_top\display_top.dca}
export_single_ppd \
    -name {MPFS250T_ES} \
    -file {D:\Gayathri\polarfire_soc\iciclekit_yoshi-vga_wrking\iciclekit_yoshi-vga\designer\display_top\export/tempExport\display_top.ppd}

save_project
close_project
