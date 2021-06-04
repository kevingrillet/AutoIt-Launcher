#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

If $CmdLine[0] = 1 Then
	$Proc = $CmdLine[1]
Else
	Exit
EndIf

While ProcessExists($Proc)
	ProcessClose($Proc)
WEnd

Exit

