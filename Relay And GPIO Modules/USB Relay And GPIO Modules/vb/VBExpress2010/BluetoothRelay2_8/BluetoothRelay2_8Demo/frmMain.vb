
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

'This demo code demonstrates how to use operate and read status from relays.

Public Class frmMain

    Private Sub btnOpenPort_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOpenPort.Click

        On Error Resume Next

        ' Open the serial port selected. This relay module presents itself to 
        ' the operating system as a serial port. So using this device is 
        ' as easy as interacting with as serial port

        SerialPort1.PortName = "COM" + txtPortNumber.Text
        SerialPort1.Open()

        If (Not SerialPort1.IsOpen) Then
            MsgBox("Could not open the specified port", MsgBoxStyle.Critical)
        Else
            MsgBox("Port opened successfuly", MsgBoxStyle.Information)
        End If
    End Sub

    Private Sub frmMain_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
        ' Close the serial port before exiting
        If (SerialPort1.IsOpen) Then
            SerialPort1.Close()
        End If
    End Sub

    Private Sub btnSetStatus_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSetStatus.Click
        If SerialPort1.IsOpen Then
            If Val(txtRelayNumber1.Text) < 8 Then
                'Send a command to output the selected state to the selected relay.
                'The commands that is used to accomplish this acton are "relay on" and
                '"relay off". It is important to send a Carriage Return character
                '(ASCII value 13) to emulate the ENTER key. The command will be executed
                'only when the relay module detects Carriage Return character.
                If (Val(txtRelayStatus.Text) = 0) Then
                    SerialPort1.Write("relay off " + txtRelayNumber1.Text + Chr(13))
                ElseIf (Val(txtRelayStatus.Text) = 1) Then
                    SerialPort1.Write("relay on " + txtRelayNumber1.Text + Chr(13))
                Else
                    MsgBox("Relay State must be 0 or 1", MsgBoxStyle.Critical)
                End If
            Else
                MsgBox("Enter a valid relay number", MsgBoxStyle.Critical)
            End If
        Else
            MsgBox("Open a port before sending commands", MsgBoxStyle.Critical)
        End If
    End Sub

    Private Sub btnGetStatus_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnGetStatus.Click
        Dim readData As String

        If SerialPort1.IsOpen Then
            'Discard any existing data from teh receive buffer. This is an important step
            SerialPort1.DiscardInBuffer()

            'Read the state of the selected relay. The command that is used to accomplish this
            'acton is "relay read". It is important to send a Carriage Return character
            '(ASCII value 13) to emulate the ENTER key. The command will be executed only
            'when the relay module detects Carriage Return character.It is important to note
            'that the device echoes every single character sent to it and so when you read
            'the response, the data that is read will include the command itself, a carriage
            'return, the response which you are interested in, a '>' character and another 
            'carriage return. You will need to extract the response from this bunch of data. 
            If Val(txtRealyNumber2.Text) < 8 Then
                SerialPort1.Write("relay read " + txtRealyNumber2.Text + Chr(13))
                'Bluetooth module needs a little extra time for command completion
                System.Threading.Thread.Sleep(200)
                readData = SerialPort1.ReadExisting
                MsgBox("Relay Status = " + Mid(readData, 15, 3))
            Else
                MsgBox("Enter a valid Relay number", MsgBoxStyle.Critical)
            End If
        Else
            MsgBox("Open a port before sending commands", MsgBoxStyle.Critical)
        End If
    End Sub

End Class