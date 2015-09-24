@echo off
setlocal EnableExtensions EnableDelayedExpansion
call C:\Xilinx\14.7\ISE_DS\settings64.bat

cls
echo.
echo ***************************************************************
echo                        Numato Lab 
echo ***************************************************************
echo ***************************************************************
echo               CS4344 Audio Expansion Module
echo ***************************************************************
echo.
echo.
echo ** note : If build steps does not execute, please make sure 
echo           path to Xilinx build tools is registered in PATH variable.
echo.
echo.
echo Generate bit and bin file for !!
echo.

: EnterChoice

echo      Sr No.           Board              Supported
echo      --------------------------------------------------                  
echo        1     Elbert V2                       Yes
echo        2     Mimas                           Yes
echo        3     Mimas V2                        Yes
echo        4     Saturn                          Yes
echo        5     Waxwing Carrier                 Yes
echo        6     Waxwing Development Board       Yes  
echo. 

set "choice=%globalparam1%"
goto :aCheck
:aPrompt
set /p "choice=Enter Choice: "
:aCheck
if "%choice%"=="" goto :aPrompt

echo.
echo.


if "%choice%" == "1" ( 
    echo Sit back and relax while we generate the files for you
	  set _ucf=ucf/ElbertV2.ucf 
	  set _device=xc3s50a-tq144-4
	  goto BuildProj
) else ( 
      if "%choice%" == "3" ( 
          echo Sit back and relax while we generate the files for you
	        set _ucf=ucf/MimasV2.ucf 
				  set _device=xc6slx9-csg324-2
				  goto BuildProj
      ) else (
            if "%choice%" == "4" ( 
				        :DeviceCheck
					        echo Which is your Saturn Board?
						      echo      A Saturn LX16
						      echo      B Saturn LX45
						      
                  set "device=%globalparam1%"
                  goto :bCheck
                        
                  :bPrompt
                    set /p "device=Enter Choice: "
                  
                  :bCheck
                    if "%device%"=="" goto :bPrompt
						 
						      if "%device%" == "A" (
						          set _ucf=ucf/SaturnExpansionLX16.ucf 
				              set _device=xc6slx16-csg324-2
						      ) else (
						            if "%device%" == "B" (
						                set _ucf=ucf/SaturnExpansionLX45.ucf 
				                    set _device=xc6slx45-csg324-2
							          ) else (
								              echo Wrong Selection
									            goto DeviceCheck
								          )
						        )
                echo Sit back and relax while we generate the files for you
				        goto BuildProj
            ) else (
                  if "%choice%" == "5" ( 
                      echo Sit back and relax while we generate the files for you
							        set _ucf=ucf/WaxwingCarrier.ucf 
				              set _device=xc6slx45-csg324-2
				              goto BuildProj
                  ) else (
                        if "%choice%" == "6" ( 
                            echo Sit back and relax while we generate the files for you
	                          set _ucf=ucf/WaxwingDevBoard.ucf 
				                    set _device=xc6slx45-csg324-2
				                    goto BuildProj
                        ) else ( 
                              if "%choice%" == "2" (
                                  echo Sit back and relax while we generate the files for you
	                                set _ucf=ucf/MimasExpansion.ucf 
				                          set _device=xc6slx9-tqg144-2
				                          goto BuildProj	
                              ) else (										 
                                    echo Incorrect choice. Please enter choice from one of the below.
                                    goto EnterChoice
                                )										 
                          )
                    )
              )
        )
  )
  

:BuildProj		

  
if "%choice%" == "1" (
   set _family=build/spartan3/
   del /Q /F build\spartan3\*.bin
   del /Q /F build\spartan3\*.bit
) else (
      set _family=build/spartan6/
      del /Q /F build\spartan6\*.bin
      del /Q /F build\spartan6\*.bit
  )    
 
del /Q /F binary\*.bin
del /Q /F binary\*.bit



xst -intstyle ise -filter "iseconfig/filter.filter" -ifn ""%_family%"AudioCS4344ExpansionModule.xst" -ofn ""%_family%"AudioCS4344ExpansionModule.syr" 
ngdbuild -filter "iseconfig/filter.filter" -intstyle ise -dd _ngo -nt timestamp -uc %_ucf% -p %_device% "%_family%"AudioCS4344ExpansionModule.ngc "%_family%"AudioCS4344ExpansionModule.ngd  
map -filter "iseconfig/filter.filter" -intstyle ise -p %_device% -w -logic_opt off -ol high -t 1  -register_duplication off -r 4 -global_opt off  -ir off -pr off  -power off -o "%_family%"AudioCS4344ExpansionModule_map.ncd "%_family%"AudioCS4344ExpansionModule.ngd "%_family%"AudioCS4344ExpansionModule.pcf 
par -filter "iseconfig/filter.filter" -w -intstyle ise -ol high -mt off "%_family%"AudioCS4344ExpansionModule_map.ncd "%_family%"AudioCS4344ExpansionModule.ncd "%_family%"AudioCS4344ExpansionModule.pcf 
trce -filter iseconfig/filter.filter -intstyle ise -v 3 -s 2 -n 3 -fastpaths -xml "%_family%"AudioCS4344ExpansionModule.twx "%_family%"AudioCS4344ExpansionModule.ncd -o "%_family%"AudioCS4344ExpansionModule.twr "%_family%"AudioCS4344ExpansionModule.pcf 
bitgen -filter "iseconfig/filter.filter" -intstyle ise -f "%_family%"AudioCS4344ExpansionModule.ut "%_family%"AudioCS4344ExpansionModule.ncd

goto DelFile

:EditFile
 
  if "%choice%" == "1" ( 
      ren AudioCS4344ExpansionModule.bit AudioCS4344ExpansionModule_ElbertV2.bit 
      ren AudioCS4344ExpansionModule.bin AudioCS4344ExpansionModule_ElbertV2.bin
  ) else ( 
        if "%choice%" == "3" ( 
            ren AudioCS4344ExpansionModule.bit AudioCS4344ExpansionModule_MimasV2.bit 
            ren AudioCS4344ExpansionModule.bin AudioCS4344ExpansionModule_MimasV2.bin
        ) else (
              if "%choice%" == "4" ( 
						      if "%device%" == "A" (
						          ren AudioCS4344ExpansionModule.bit AudioCS4344ExpansionModule_SaturnExpansionLX16.bit 
                      ren AudioCS4344ExpansionModule.bin AudioCS4344ExpansionModule_SaturnExpansionLX16.bin
						      ) else (
						            if "%device%" == "B" (
						                ren AudioCS4344ExpansionModule.bit AudioCS4344ExpansionModule_SaturnExpansionLX45.bit 
                            ren AudioCS4344ExpansionModule.bin AudioCS4344ExpansionModule_SaturnExpansionLX45.bin									
							          )
						        )
              ) else (
                    if "%choice%" == "5" ( 
                        ren AudioCS4344ExpansionModule.bit AudioCS4344ExpansionModule_WaxwingCarrier.bit 
                        ren AudioCS4344ExpansionModule.bin AudioCS4344ExpansionModule_WaxwingCarrier.bin
                    ) else (
                          if "%choice%" == "6" ( 
                              ren AudioCS4344ExpansionModule.bit AudioCS4344ExpansionModule_WaxwingDevBoard.bit 
                              ren AudioCS4344ExpansionModule.bin AudioCS4344ExpansionModule_WaxwingDevBoard.bin
                          ) else (
                                if "%choice%" == "2" (
                                    ren AudioCS4344ExpansionModule.bit AudioCS4344ExpansionModule_MimasExpansion.bit 
                                    ren AudioCS4344ExpansionModule.bin AudioCS4344ExpansionModule_MimasExpansion.bin
                                )
                            ) 
                      )
                )
          )
    )
 	cd../..
	if not exist binary mkdir binary
    if "%choice%" == "1" ( 
      copy  build\spartan3\*.bin binary
      copy  build\spartan3\*.bit binary
    ) else (
        copy  build\spartan6\*.bin binary
        copy  build\spartan6\*.bit binary
      )     
  goto Exit 

: DelFile
  cd "%_family%"
  del /Q /F *.stx
  del /Q /F _summary.html
  del /Q /F *.lso
  del /Q /F *.syr
  del /Q /F _xst.xrpt
  del /Q /F webtalk_pn.xml
  del /Q /F *.ngr
  del /Q /F xst
  del /Q /F *.cmd_log
  del /Q /F xst.xmsgs
  del /Q /F *.bld
  del /Q /F _ngdbuild.xrpt
  del /Q /F _ngo
  del /Q /F xlnx_auto_0_xdb
  del /Q /F ngdbuild.xmsgs
  del /Q /F _map.map
  del /Q /F _map.mrp
  del /Q /F _map.xrpt
  del /Q /F _map.ncd
  del /Q /F *.pcf
  del /Q /F _map.ngm
  del /Q /F _usage.xml
  del /Q /F _summary.xml
  del /Q /F map.xmsgs
  del /Q /F *.pad
  del /Q /F *.par
  del /Q /F *.unroutes
  del /Q /F *.xpi
  del /Q /F *_par.xrpt
  del /Q /F _pad.txt
  del /Q /F _pad.csv
  del /Q /F *.ptwx
  del /Q /F par.xmsgs
  del /Q /F *.twr
  del /Q /F *.twx
  del /Q /F trce.xmsgs
  del /Q /F *.drc
  del /Q /F *.bgn
  del /Q /F webtalk.log
  del /Q /F usage_statistics_webtalk.html
  del /Q /F bitgen.xmsgs
  del /Q /F *.html
  del /Q /F *.map
  del /Q /F *.mrp
  del /Q /F *.ngm
  del /Q /F *.xrpt
  del /Q /F *.csv
  del /Q /F *.txt
  del /Q /F *.xml
  del /Q /F *.ncd
  del /Q /F *.log
  del /Q /F *.html
  del /Q /F *.xwbt
goto :status

:status
 cls
 if exist *.bin if exist *.bit  goto EditFile
 if not exist *.bin if not exist *.bit  goto EditFile
     
:Exit
  del  build\spartan3\*.bin 
  del  build\spartan3\*.bit
  del  build\spartan6\*.bin 
  del  build\spartan6\*.bit
  del /Q /F *.xml
  del /Q /F *.html
  del /Q /F *.xrpt
  rmdir /S /Q _ngo
  rmdir /S /Q xlnx_auto_0_xdb
  rmdir /S /Q _xmsgs 
  cls
  echo ***************************************************************
  echo                        Numato Lab 
  echo ***************************************************************
  echo ***************************************************************
  echo               CS4344 Audio Expansion Module
  echo ***************************************************************
  if exist binary/*.bin if exist binary/*.bit echo Successfull
  if not exist binary/*.bin if not exist binary/*.bit echo Failed
  echo Press Enter to Exit
 
pause


