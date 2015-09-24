//---------------------------------------------------------------------------
//
// Name:        saturnflashconfigApp.h
// Author:      
// Created:     10/6/2013 12:09:49 PM
// Description: 
//
//---------------------------------------------------------------------------

#ifndef __SATURNFLASHCONFIGDLGApp_h__
#define __SATURNFLASHCONFIGDLGApp_h__

#ifdef __BORLANDC__
	#pragma hdrstop
#endif

#ifndef WX_PRECOMP
	#include <wx/wx.h>
#else
	#include <wx/wxprec.h>
#endif

class saturnflashconfigDlgApp : public wxApp
{
	public:
		bool OnInit();
		int OnExit();
};

#endif
