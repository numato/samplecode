proc RunUcfConstraintGen { nCHandle nComIdXbd nDesignId } {
   set nResult 0

   if { $nCHandle eq "" } {
      return $nResult
  }

   if { $nComIdXbd eq "" } {
      return $nResult
   }

   if { $nDesignId eq "" } {
      return $nResult
   }

   set bApiStatus [ tgi::init "1.0" "fail" "Client connected" ]
   if { $bApiStatus == 0 } {
      return 1
   }
   
   # Repository path
   set strRepoDirPath [ bsb::getRepoDirPath $nCHandle ]

   # Pin Constraints
   set strCsvFilePath [ file join $strRepoDirPath "Opsis.csv" ]

   set nResult [ \
      bsb::registerPinData $nCHandle $nComIdXbd $nDesignId $strCsvFilePath \
   ]

   if { $nResult != 0 } {
      return $nResult
   }
   
   #Default ucf
   set strUcfFilePath [ \
      file join $strRepoDirPath "default.ucf" \
   ]

   set nResult [ \
         bsb::registerRawUcfFile  \
            $nCHandle $strUcfFilePath \
      ]

   if { $nResult != 0 } {
      return $nResult
   }
   
   # User constraints for FX2 UART
   set strUcfFilePath [ \
      file join $strRepoDirPath "fX2_uart.ucf" \
   ]
   set vecBusIf [list "FX2_UART" $strUcfFilePath]

   set nResult [ \
         bsb::registerRawUcfFileForBusIf \
            $nCHandle $nDesignId $vecBusIf \
      ]

   if { $nResult != 0 } {
      return $nResult
   }

   # Indicate that we are done.
   #tgi::end 0 "Client done"
   
   return $nResult
}

