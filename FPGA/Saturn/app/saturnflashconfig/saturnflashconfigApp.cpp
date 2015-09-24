//---------------------------------------------------------------------------
//
// Name:        saturnflashconfigApp.cpp
// Author:      
// Created:     10/6/2013 12:09:49 PM
// Description: 
//
//---------------------------------------------------------------------------

#include "saturnflashconfigApp.h"
#include "saturnflashconfigDlg.h"

IMPLEMENT_APP(saturnflashconfigDlgApp)

bool saturnflashconfigDlgApp::OnInit()
{
	saturnflashconfigDlg* dialog = new saturnflashconfigDlg(NULL);
	SetTopWindow(dialog);
	dialog->Show(true);		
	return true;
}
 
int saturnflashconfigDlgApp::OnExit()
{
	return 0;
}
