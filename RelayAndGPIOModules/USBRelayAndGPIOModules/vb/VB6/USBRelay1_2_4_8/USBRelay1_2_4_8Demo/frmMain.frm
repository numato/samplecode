VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "mscomm32.ocx"
Begin VB.Form frmMain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "USBRelay1_2_4_8Demo"
   ClientHeight    =   5700
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   3375
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   ScaleHeight     =   5700
   ScaleWidth      =   3375
   StartUpPosition =   2  'CenterScreen
   Begin MSCommLib.MSComm MSComm1 
      Left            =   30
      Top             =   915
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      DTREnable       =   0   'False
      InputLen        =   64
      SThreshold      =   1
   End
   Begin VB.Frame Frame3 
      Caption         =   "Get Relay Status"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1590
      Left            =   120
      TabIndex        =   10
      Top             =   3900
      Width           =   3120
      Begin VB.TextBox txtRelayNumber2 
         Alignment       =   2  'Center
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   315
         Left            =   1680
         TabIndex        =   12
         Text            =   "0"
         Top             =   360
         Width           =   975
      End
      Begin VB.CommandButton cmdGetStatus 
         Caption         =   "Get Status"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   480
         Left            =   465
         TabIndex        =   11
         Top             =   900
         Width           =   1980
      End
      Begin VB.Label Label5 
         Caption         =   "Relay Number"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   210
         TabIndex        =   13
         Top             =   420
         Width           =   1215
      End
   End
   Begin VB.Frame Frame2 
      Caption         =   "Set Relay Status"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1920
      Left            =   120
      TabIndex        =   4
      Top             =   1875
      Width           =   3120
      Begin VB.CommandButton cmdSetStatus 
         Caption         =   "Set Status"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   480
         Left            =   450
         TabIndex        =   9
         Top             =   1290
         Width           =   1980
      End
      Begin VB.TextBox txtRelayStatus1 
         Alignment       =   2  'Center
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   315
         Left            =   1665
         TabIndex        =   8
         Text            =   "0"
         Top             =   780
         Width           =   975
      End
      Begin VB.TextBox txtRelayNumber1 
         Alignment       =   2  'Center
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   315
         Left            =   1680
         TabIndex        =   6
         Text            =   "0"
         Top             =   360
         Width           =   975
      End
      Begin VB.Label Label3 
         Caption         =   "Relay Status"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   210
         TabIndex        =   7
         Top             =   840
         Width           =   1215
      End
      Begin VB.Label Label2 
         Caption         =   "Relay Number"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   210
         TabIndex        =   5
         Top             =   420
         Width           =   1215
      End
   End
   Begin VB.CommandButton btnOpenPort 
      Caption         =   "Open Port"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   480
      Left            =   675
      TabIndex        =   3
      Top             =   975
      Width           =   1980
   End
   Begin VB.Frame Frame1 
      Height          =   120
      Left            =   0
      TabIndex        =   2
      Top             =   1605
      Width           =   3390
   End
   Begin VB.TextBox txtCommPort 
      Alignment       =   2  'Center
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   1830
      TabIndex        =   1
      Text            =   "0"
      Top             =   315
      Width           =   975
   End
   Begin VB.Label Label1 
      Caption         =   "Port Number"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   375
      TabIndex        =   0
      Top             =   375
      Width           =   1215
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

'License
'-------
'This code is published and shared by Numato Systems Pvt Ltd under GNU LGPL
'license with the hope that it may be useful. Read complete license at
'http://www.gnu.org/licenses/lgpl.html or write to Free Software Foundation,
'51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA

'Simplicity and understandability is the primary philosophy followed while
'writing this code. Sometimes at the expence of standard coding practices and
'best practices. It is your responsibility to independantly assess and implement
'coding practices that will satisfy safety and security necessary for your final
'application.

'This demo code demonstrates how to use Relays on a USB Relay Module

'------------------------------------------------------------------------------
'------------------------------------------------------------------------------

Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

Private Sub btnOpenPort_Click()
    'Please notice the properties of MScomm1 MSComm control. You will need to
    'use the same settings in your project
        
    'Check if the comm port number is greater than 16. MSComm32.ocx shipped with
    'VB6 supports only up to COM16. If your serial port number is larger than 16
    'Please reassign a smaller number to the port.
    If Val(txtCommPort.Text) > 16 Then
        MsgBox "VB6 supports only up to COM16", vbCritical
    Else
        'Try to open the oprt only if the port is not already opened
        If MSComm1.PortOpen = False Then
            MSComm1.CommPort = Val(txtCommPort.Text)
            MSComm1.PortOpen = True
            
            'Check if the port successfuly opened
            If MSComm1.PortOpen = False Then
                MsgBox "Could not open the specified COM port"
            Else
                MsgBox "Port opened successfuly"
            End If
        Else
            MsgBox "Port already open"
        End If
    End If
    
End Sub



Private Sub cmdSetStatus_Click()
    'Send a command to output the selected logic state to the selected Relay.
    'The commands that is used to accomplish this acton are "relay on" and
    '"relay off". It is important to send a Carriage Return character
    '(ASCII value 13) to emulate the ENTER key. The command will be executed
    'only when the Relay module detects Carriage Return character.Please
    ' notice below that no space is explicitly given as part of command
    'after set/clear. This is because str() function returns string with
    'a prepended space.
    If MSComm1.PortOpen = True Then
        If Val(txtRelayStatus1) = 0 Then
            MSComm1.Output = "relay off" + Str(Val(txtRelayNumber1)) + Chr(13)
        Else
            MSComm1.Output = "relay on" + Str(Val(txtRelayNumber1)) + Chr(13)
        End If
    Else
        MsgBox "Port not open"
    End If
        
End Sub

Private Sub cmdGetStatus_Click()

    Dim readData As String
    
    If MSComm1.PortOpen = True Then

        'Discard any existing data from the receive buffer. This is an important step
        MSComm1.InBufferCount = 0
    
        'Read the state of the selected Relay. The command that is used to accomplish this
        'acton is "relay read". It is important to send a Carriage Return character
        '(ASCII value 13) to emulate the ENTER key. The command will be executed only
        'when the Relay module detects Carriage Return character.It is important to note
        'that the device echoes every single character sent to it and so when you read
        'the response, the data that is read will include the command itself, a carriage
        'return, the response which you are interested in, a '>' character and another
        'carriage return. You will need to extract the response from this bunch of data.
        
        If Val(txtRelayNumber2.Text) < 8 Then
                MSComm1.Output = ("relay read" + Str(Val(txtRelayNumber2.Text)) + Chr(13))
                Sleep (10)
                readData = MSComm1.Input
                MsgBox ("Relay Status = " + Mid(readData, 15, 3))
            Else
                MsgBox ("Enter a valid Relay number")
            End If
    
    Else
        MsgBox "Port not open"
    End If
        
End Sub


Private Sub Form_Unload(Cancel As Integer)
    If MSComm1.PortOpen = True Then
        MSComm1.PortOpen = False
    End If
End Sub
