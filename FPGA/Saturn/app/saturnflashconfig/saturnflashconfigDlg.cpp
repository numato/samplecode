///-----------------------------------------------------------------
///
/// @file      saturnflashconfigDlg.cpp
/// @author    
/// Created:   10/6/2013 12:09:49 PM
/// @section   DESCRIPTION
///            saturnflashconfigDlg class implementation
///
///------------------------------------------------------------------

#include "saturnflashconfigDlg.h"

//Do not add custom headers
//wxDev-C++ designer will remove them
////Header Include Start
////Header Include End

//----------------------------------------------------------------------------
// saturnflashconfigDlg
//----------------------------------------------------------------------------
//Add Custom Events only in the appropriate block.
//Code added in other places will be removed by wxDev-C++
////Event Table Start
BEGIN_EVENT_TABLE(saturnflashconfigDlg,wxDialog)
	////Manual Code Start
	////Manual Code End
	
	EVT_CLOSE(saturnflashconfigDlg::OnClose)
	EVT_INIT_DIALOG(saturnflashconfigDlg::saturnflashconfigDlgInitDialog)
	EVT_BUTTON(ID_WXBTNDOWNLOADCONFIG,saturnflashconfigDlg::WxBtnDownloadConfigClick)
	EVT_BUTTON(ID_WXBTNLOADFILE,saturnflashconfigDlg::WxBtnLoadFileClick)
	EVT_BUTTON(ID_WXBTNSCAN,saturnflashconfigDlg::WxBtnScanClick)
END_EVENT_TABLE()
////Event Table End

saturnflashconfigDlg::saturnflashconfigDlg(wxWindow *parent, wxWindowID id, const wxString &title, const wxPoint &position, const wxSize& size, long style)
: wxDialog(parent, id, title, position, size, style)
{
	CreateGUIControls();
}

saturnflashconfigDlg::~saturnflashconfigDlg()
{
} 

void saturnflashconfigDlg::CreateGUIControls()
{
	//Do not add custom code between
	//GUI Items Creation Start and GUI Items Creation End.
	//wxDev-C++ designer will remove them.
	//Add the custom code before or after the blocks
	////GUI Items Creation Start

	WxDlgLoadBitFile =  new wxFileDialog(this, _("Please select a file"), _(""), _(""), _("Binary Files (*.bin)|*.bin|All Files (*.*)|*.*"), wxFD_OPEN);

	WxBtnDownloadConfig = new wxButton(this, ID_WXBTNDOWNLOADCONFIG, _("Program Flash"), wxPoint(195, 180), wxSize(170, 25), 0, wxDefaultValidator, _("WxBtnDownloadConfig"));

	WxBtnLoadFile = new wxButton(this, ID_WXBTNLOADFILE, _("Load Binary File"), wxPoint(9, 180), wxSize(170, 25), 0, wxDefaultValidator, _("WxBtnLoadFile"));

	wxArrayString arrayStringFor_WxComboSelectDev;
	WxComboSelectDev = new wxComboBox(this, ID_WXCOMBOSELECTDEV, _("Select Device"), wxPoint(195, 146), wxSize(170, 21), arrayStringFor_WxComboSelectDev, wxTE_READONLY, wxDefaultValidator, _("WxComboSelectDev"));

	WxGaugeProgress = new wxGauge(this, ID_WXGAUGEPROGRESS, 100, wxPoint(10, 112), wxSize(355, 22), wxGA_HORIZONTAL, wxDefaultValidator, _("WxGaugeProgress"));
	WxGaugeProgress->SetRange(100);
	WxGaugeProgress->SetValue(0);

	wxEditLog = new wxTextCtrl(this, ID_WXEDITLOG, _(""), wxPoint(10, 7), wxSize(355, 100), wxTE_READONLY | wxTE_BESTWRAP | wxTE_MULTILINE, wxDefaultValidator, _("wxEditLog"));
	wxEditLog->SetFont(wxFont(8, wxSWISS, wxNORMAL, wxBOLD, false));

	WxBtnScan = new wxButton(this, ID_WXBTNSCAN, _("Scan For Devices"), wxPoint(10, 145), wxSize(170, 25), 0, wxDefaultValidator, _("WxBtnScan"));

	SetTitle(_("Saturn Flash Config Tool"));
	SetIcon(wxNullIcon);
	SetSize(8,8,381,252);
	Center();
	
	////GUI Items Creation End
}

void saturnflashconfigDlg::OnClose(wxCloseEvent& /*event*/)
{
	Destroy();
}

/*
 * WxBtnScanClick
 */
void saturnflashconfigDlg::WxBtnScanClick(wxCommandEvent& event)
{
    WxComboSelectDev->Clear();
    scanDevices();
    WxComboSelectDev->Select(0);
}

/*
 * saturnflashconfigDlgInitDialog
 */
void saturnflashconfigDlg::saturnflashconfigDlgInitDialog(wxInitDialogEvent& event)
{
    addLog(wxT("SATURN FPGA CONFIGURATION TOOL"));
    addLog(wxT("http://www.numato.com"));
    addLog(wxT(" "));
    
    if(scanDevices())
    {
       addLog(wxT("Initialization failed"));
    }
    else
    {
        WxComboSelectDev->Select(0);
    }
}

void saturnflashconfigDlg::clearLog()
{
    wxEditLog->Clear();
}

void saturnflashconfigDlg::addLog(wxString log)
{
    wxEditLog->AppendText(log + wxT("\n"));
}

void saturnflashconfigDlg::addDeviceToList(wxString deviceName)
{
    WxComboSelectDev->Append(deviceName);
}

void saturnflashconfigDlg::updateStatus(unsigned int value)
{
    WxGaugeProgress->SetValue(value);
}

void saturnflashconfigDlg::setMaxStatusValue(unsigned int maxValue)
{
    WxGaugeProgress->SetRange(maxValue);
}

void saturnflashconfigDlg::refreshUI()
{
    wxGetApp().Yield();
}

/*
 * WxBtnLoadFileClick
 */
void saturnflashconfigDlg::WxBtnLoadFileClick(wxCommandEvent& event)
{
	if(WxDlgLoadBitFile->ShowModal() == wxID_OK)
	{
        currentFile = WxDlgLoadBitFile->GetPath();
        addLog(wxT("File selected \"") + WxDlgLoadBitFile->GetFilename()+ wxT("\"") );
        
        LoadFile(currentFile.c_str());
    }
}

/*
 * WxBtnDownloadConfigClick
 */
void saturnflashconfigDlg::WxBtnDownloadConfigClick(wxCommandEvent& event)
{
    unsigned int status = 0;   
    
    openSPI(0);
    sectorErase(bitFileSize);
    //bulkErase();
    programFlash();
    verify();
    closeSPI();
    
    addLog(wxT("--------------------------------------------------"));
}
