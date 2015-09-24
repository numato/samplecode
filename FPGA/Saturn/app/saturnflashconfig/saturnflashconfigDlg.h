///-----------------------------------------------------------------
///
/// @file      saturnflashconfigDlg.h
/// @author    
/// Created:   10/6/2013 12:09:49 PM
/// @section   DESCRIPTION
///            saturnflashconfigDlg class declaration
///
///------------------------------------------------------------------

#ifndef __SATURNFLASHCONFIGDLG_H__
#define __SATURNFLASHCONFIGDLG_H__

#ifdef __BORLANDC__
	#pragma hdrstop
#endif

#ifndef WX_PRECOMP
	#include <wx/wx.h>
	#include <wx/dialog.h>
#else
	#include <wx/wxprec.h>
#endif

//Do not add custom headers between 
//Header Include Start and Header Include End.
//wxDev-C++ designer will remove them. Add custom headers after the block.
////Header Include Start
#include <wx/filedlg.h>
#include <wx/combobox.h>
#include <wx/gauge.h>
#include <wx/textctrl.h>
#include <wx/button.h>
////Header Include End

#include "saturnconfig.h"

// For wxGetApp()
#include "saturnflashconfigApp.h"
DECLARE_APP(saturnflashconfigDlgApp)
// end For wxGetApp()

////Dialog Style Start
#undef saturnflashconfigDlg_STYLE
#define saturnflashconfigDlg_STYLE wxCAPTION | wxSYSTEM_MENU | wxDIALOG_NO_PARENT | wxMINIMIZE_BOX | wxCLOSE_BOX
////Dialog Style End

class saturnflashconfigDlg : public wxDialog, saturnConfig
{
	private:
		DECLARE_EVENT_TABLE();
		
	public:
		saturnflashconfigDlg(wxWindow *parent, wxWindowID id = 1, const wxString &title = wxT("Saturn Flash Config Tool"), const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = saturnflashconfigDlg_STYLE);
		virtual ~saturnflashconfigDlg();
		void WxBtnScanClick(wxCommandEvent& event);
		void saturnflashconfigDlgInitDialog(wxInitDialogEvent& event);
		void WxBtnLoadFileClick(wxCommandEvent& event);
		void WxBtnDownloadConfigClick(wxCommandEvent& event);
	
	private:
		//Do not add custom control declarations between 
		//GUI Control Declaration Start and GUI Control Declaration End.
		//wxDev-C++ will remove them. Add custom code after the block.
		////GUI Control Declaration Start
		wxFileDialog *WxDlgLoadBitFile;
		wxButton *WxBtnDownloadConfig;
		wxButton *WxBtnLoadFile;
		wxComboBox *WxComboSelectDev;
		wxGauge *WxGaugeProgress;
		wxTextCtrl *wxEditLog;
		wxButton *WxBtnScan;
		////GUI Control Declaration End
		
	private:
		//Note: if you receive any error with these enum IDs, then you need to
		//change your old form code that are based on the #define control IDs.
		//#defines may replace a numeric value for the enum names.
		//Try copy and pasting the below block in your old form header files.
		enum
		{
			////GUI Enum Control ID Start
			ID_WXBTNDOWNLOADCONFIG = 1007,
			ID_WXBTNLOADFILE = 1006,
			ID_WXCOMBOSELECTDEV = 1005,
			ID_WXGAUGEPROGRESS = 1004,
			ID_WXEDITLOG = 1003,
			ID_WXBTNSCAN = 1002,
			////GUI Enum Control ID End
			ID_DUMMY_VALUE_ //don't remove this value unless you have other enum values
		};
	
	private:
		void OnClose(wxCloseEvent& event);
		void CreateGUIControls();
		
	private:
        wxString currentFile;
        
        void clearLog();
        void addLog(wxString log);
        void addDeviceToList(wxString deviceName);
        void updateStatus(unsigned int value);
        void setMaxStatusValue(unsigned int maxValue);
        void refreshUI();
};

#endif
