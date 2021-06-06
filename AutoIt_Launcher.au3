#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         kevingrillet

 Script Function:
	Small launcher.

#ce ----------------------------------------------------------------------------

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icons\x48\launcher.ico
#AutoIt3Wrapper_Outfile=AutoIt_Launcher.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Description=Small launcher
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Copyright (C) 2021
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Field=Compiler Date|%date%
#AutoIt3Wrapper_Res_Field=Compiler Heure|%time%
#AutoIt3Wrapper_Res_Field=Compiler Version|AutoIt v%AutoItVer%
#AutoIt3Wrapper_Res_Field=Author|kevingrillet
#AutoIt3Wrapper_Res_Field=Github|https://github.com/kevingrillet/AutoIt-Launcher
#AutoIt3Wrapper_Add_Constants=n
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Region ### PRAGMA ###
#pragma compile(AutoItExecuteAllowed, True)
#EndRegion ### PRAGMA ###

#Region ### INCLUDES ###
#include <Array.au3>
#include <ButtonConstants.au3>
#include <Date.au3>
#include <EditConstants.au3>
#include <File.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TrayConstants.au3>
#include <WindowsConstants.au3>
#EndRegion ### INCLUDES ###

#Region ### CONSTANTS ###
;~ Button struct
Const $CST_HINT = 0
Const $CST_ICON = $CST_HINT + 1
Const $CST_MODE = $CST_ICON + 1
Const $CST_RUN_PROGRAM = $CST_MODE + 1
Const $CST_RUN_WORKINGDIR = $CST_RUN_PROGRAM + 1
Const $CST_SHELL_FILENAME = $CST_RUN_WORKINGDIR + 1
Const $CST_SHELL_PARAMETERS = $CST_SHELL_FILENAME + 1
Const $CST_SHELL_WORKINGDIR = $CST_SHELL_PARAMETERS + 1
Const $CST_SCRIPT_PATH = $CST_SHELL_WORKINGDIR + 1
;~ Button mode
Const $CST_RUN = 0
Const $CST_SHELLEXECUTE = 1
Const $CST_SCRIPT = 2
#EndRegion ### CONSTANTS ###

#Region ### VARIABLES ###
Dim $aListButton[1][1]
Dim $aDataButton[1][$CST_SCRIPT_PATH + 1]
Local $bEdit = False
Local $iButtonIDEdit = -1
Local $sPathButtons = @ScriptDir & "\AutoIt_Launcher_buttons.data"
Local $sPathIni = @ScriptDir & "\AutoIt_Launcher.ini"
Local $sPathLog = @ScriptDir & "\AutoIt_Launcher.log"
#EndRegion ### VARIABLES ###

#Region ### OPT ###
Opt("GUIOnEventMode", 1) ;0=disabled, 1=OnEvent mode enabled
Opt("MustDeclareVars", 1) ;0=no, 1=require pre-declaration
Opt("TrayAutoPause", 0) ;0=no pause, 1=Pause
Opt("TrayMenuMode", 3) ;0=append, 1=no default menu, 2=no automatic check, 4=menuitemID  not return
Opt("TrayOnEventMode", 1) ;0=disable, 1=enable
#EndRegion ### OPT ###

#Region ### START Koda GUI section ### Form=d:\users\kevin\documents\github\autoit-launcher\forms\fglobalsettings.kxf
Local $fGlobalSettings = GUICreate("Global Settings", 158, 157, -1, -1, $WS_SYSMENU)
GUISetOnEvent($GUI_EVENT_CLOSE, "fGlobalSettingsClose")
Local $lCols = GUICtrlCreateLabel("Columns", 8, 43, 44, 17)
Local $lRow = GUICtrlCreateLabel("Row", 8, 11, 26, 17)
Local $iRow = GUICtrlCreateInput("1", 56, 8, 89, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_RIGHT, $ES_NUMBER))
GUICtrlSetOnEvent(-1, "__onChange")
Local $iCol = GUICtrlCreateInput("1", 56, 40, 89, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_RIGHT, $ES_NUMBER))
GUICtrlSetOnEvent(-1, "__onChange")
Local $cbLog = GUICtrlCreateCheckbox("Save log", 8, 72, 97, 17)
GUICtrlSetOnEvent(-1, "__onChange")
Local $bSaveSettings = GUICtrlCreateButton("Save Global Settings", 8, 96, 139, 25)
GUICtrlSetOnEvent(-1, "bSaveSettingsClick")
;~ GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

#Region ### START Koda GUI section ### Form=d:\users\kevin\documents\github\autoit-launcher\forms\fbuttonsettings.kxf
Local $fButtonSettings = GUICreate("Button Settings", 498, 431, -1, -1, $WS_SYSMENU, $WS_EX_ACCEPTFILES)
GUISetOnEvent($GUI_EVENT_CLOSE, "fButtonSettingsClose")
Local $lButtonHint = GUICtrlCreateLabel("Button Hint", 16, 19, 57, 17)
Local $iButtonHint = GUICtrlCreateInput("", 104, 16, 369, 21)
GUICtrlSetOnEvent(-1, "__onChange")
Local $lButtonIcon = GUICtrlCreateLabel("Icon", 16, 51, 25, 17)
Local $iButtonIcon = GUICtrlCreateInput("", 104, 48, 289, 21)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
GUICtrlSetOnEvent(-1, "__onChange")
Local $bIcon = GUICtrlCreateButton("Open", 400, 47, 74, 23)
GUICtrlSetOnEvent(-1, "bIconClick")
Local $gGroupSettings = GUICtrlCreateGroup("", 8, 80, 473, 281)
Local $rRun = GUICtrlCreateRadio("Run", 16, 96, 113, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetOnEvent(-1, "rClick")
Local $rCustomScript = GUICtrlCreateRadio("Custom Script", 16, 304, 113, 17)
GUICtrlSetOnEvent(-1, "rClick")
Local $lRunProgram = GUICtrlCreateLabel("Program", 32, 123, 43, 17)
Local $iRunProgram = GUICtrlCreateInput("", 104, 120, 369, 21)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
GUICtrlSetOnEvent(-1, "__onChange")
Local $lRunWorkingdir = GUICtrlCreateLabel("Working Dir.", 32, 155, 63, 17)
Local $iRunWorkingdir = GUICtrlCreateInput("", 104, 152, 369, 21)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
GUICtrlSetOnEvent(-1, "__onChange")
Local $rShellExecute = GUICtrlCreateRadio("ShellExecute", 16, 184, 113, 17)
GUICtrlSetOnEvent(-1, "rClick")
Local $lShellFilename = GUICtrlCreateLabel("Filename", 32, 211, 46, 17)
Local $iShellFilename = GUICtrlCreateInput("", 104, 208, 369, 21)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
GUICtrlSetOnEvent(-1, "__onChange")
Local $lShellParameters = GUICtrlCreateLabel("Parameters", 32, 243, 57, 17)
Local $iShellWorkingdir = GUICtrlCreateInput("", 104, 272, 369, 21)
GUICtrlSetOnEvent(-1, "__onChange")
Local $lShellWorkingdir = GUICtrlCreateLabel("Working Dir.", 32, 275, 63, 17)
Local $iShellParameters = GUICtrlCreateInput("", 104, 240, 369, 21)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
GUICtrlSetOnEvent(-1, "__onChange")
Local $lScriptPath = GUICtrlCreateLabel("Path", 32, 331, 26, 17)
Local $iScriptPath = GUICtrlCreateInput("", 104, 328, 289, 21)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
GUICtrlSetOnEvent(-1, "__onChange")
Local $bScriptPath = GUICtrlCreateButton("Open", 400, 327, 74, 23)
GUICtrlSetOnEvent(-1, "bScriptPathClick")
GUICtrlCreateGroup("", -99, -99, 1, 1)
Local $bSaveButton = GUICtrlCreateButton("Save", 7, 368, 475, 25)
GUICtrlSetOnEvent(-1, "bSaveButtonClick")
GUISetOnEvent($GUI_EVENT_DROPPED, "__onDrop")
;~ GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

#Region ### START Koda GUI section ### Form=d:\users\kevin\documents\github\autoit-launcher\forms\fautoitlauncher.kxf
Local $fAutoItLauncher = GUICreate("AutoIt Launcher", 615, 437, -1, -1, $WS_SYSMENU)
GUISetOnEvent($GUI_EVENT_CLOSE, "fAutoItLauncherClose")
GUISetOnEvent($GUI_EVENT_SECONDARYUP, "fAutoItLauncherSecondaryUp")
GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, "__onDrag")
;~ GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


#Region ### TrayIcon ###
Local $miShow = TrayCreateItem("Show AutoIt Launcher")
TrayItemSetOnEvent(-1, "__Show")
Local $miShowSettings = TrayCreateItem("Show Global Settings")
TrayItemSetOnEvent(-1, "__ShowGlobalSettings")
TrayCreateItem("")
Local $miShutDown = TrayCreateItem("Shut Down AutoIt Launcher")
TrayItemSetOnEvent(-1, "__Exit")
TraySetOnEvent($TRAY_EVENT_PRIMARYDOUBLE, "__Show")
TraySetToolTip("AutoIt Launcher")
#EndRegion ### TrayIcon ###

__Log("Starting")
__LoadIni()
If Not FileExists($sPathIni) Then
	__ShowGlobalSettings()
Else
	__LoadButtons()
	__Show()
EndIf

While 1
	Sleep(100)
WEnd

Func __BtnClick($CtrlId, $bPrimary = True)
	__Log("__BtnClick")
	Local $buttonID = 0
	For $y = 0 To UBound($aListButton) - 1 Step 1
		For $x = 0 To UBound($aListButton, 2) - 1 Step 1
			If $aListButton[$y][$x] = $CtrlId Then
				$buttonID = $y * UBound($aListButton, 2) + $x
				If $bPrimary And $buttonID <= UBound($aDataButton) And $CST_MODE < UBound($aDataButton, 2) And $aDataButton[$buttonID][$CST_MODE] <> "" Then
					Switch $aDataButton[$buttonID][$CST_MODE]
						Case $CST_RUN
							Run($aDataButton[$buttonID][$CST_RUN_PROGRAM], $aDataButton[$buttonID][$CST_RUN_WORKINGDIR])
						Case $CST_SHELLEXECUTE
							ShellExecute($aDataButton[$buttonID][$CST_SHELL_FILENAME], $aDataButton[$buttonID][$CST_SHELL_PARAMETERS], $aDataButton[$buttonID][$CST_SHELL_WORKINGDIR])
						Case $CST_SCRIPT
							__RunAU3($aDataButton[$buttonID][$CST_SCRIPT_PATH])
					EndSwitch
				Else
					__LoadButtonSettings($buttonID)
				EndIf
				ExitLoop
			EndIf
		Next
	Next
EndFunc   ;==>__BtnClick
Func __Exit()
	__Log("Exiting")
	__SaveIni()
	Exit
EndFunc   ;==>__Exit
Func __GetPath($sFilePath)
	__Log("__GetPath(" & $sFilePath & ")")
	Local $sDrive, $sDir, $sFileName, $sExtension
	_PathSplit($sFilePath, $sDrive, $sDir, $sFileName, $sExtension)
	Return $sDrive & $sDir
EndFunc   ;==>__GetPath
Func __GetExtension($sFilePath)
	__Log("__GetExtension(" & $sFilePath & ")")
	Local $sDrive, $sDir, $sFileName, $sExtension
	_PathSplit($sFilePath, $sDrive, $sDir, $sFileName, $sExtension)
	Return $sExtension
EndFunc   ;==>__GetExtension
Func __GUIVisible()
	__Log("__GUIVisible")
	Local $res = False
	If WinGetState($fAutoItLauncher) = $WIN_STATE_VISIBLE Then $res = True
	If WinGetState($fGlobalSettings) = $WIN_STATE_VISIBLE Then $res = True
	If WinGetState($fButtonSettings) = $WIN_STATE_VISIBLE Then $res = True
	Return $res
EndFunc   ;==>__GUIVisible
Func __LoadButtonSettings($buttonID)
	__Log("__LoadButtonSettings(" & $buttonID & ")")
	$iButtonIDEdit = $buttonID
	GUISetState(@SW_HIDE, $fAutoItLauncher)
	If $iButtonIDEdit <= UBound($aDataButton, 1) And $CST_SCRIPT_PATH + 1 = UBound($aDataButton, 2) Then
		GUICtrlSetData($iButtonHint, $aDataButton[$iButtonIDEdit][$CST_HINT])
		GUICtrlSetData($iButtonIcon, $aDataButton[$iButtonIDEdit][$CST_ICON])
		Switch $aDataButton[$iButtonIDEdit][$CST_MODE]
			Case $CST_RUN
				GUICtrlSetState($rRun, $GUI_CHECKED)
				GUICtrlSetState($rShellExecute, $GUI_UNCHECKED)
				GUICtrlSetState($rCustomScript, $GUI_UNCHECKED)
			Case $CST_SHELLEXECUTE
				GUICtrlSetState($rRun, $GUI_UNCHECKED)
				GUICtrlSetState($rShellExecute, $GUI_CHECKED)
				GUICtrlSetState($rCustomScript, $GUI_UNCHECKED)
			Case $CST_SCRIPT
				GUICtrlSetState($rRun, $GUI_UNCHECKED)
				GUICtrlSetState($rShellExecute, $GUI_UNCHECKED)
				GUICtrlSetState($rCustomScript, $GUI_CHECKED)
		EndSwitch
		GUICtrlSetData($iRunProgram, $aDataButton[$iButtonIDEdit][$CST_RUN_PROGRAM])
		GUICtrlSetData($iRunWorkingdir, $aDataButton[$iButtonIDEdit][$CST_RUN_WORKINGDIR])
		GUICtrlSetData($iShellFilename, $aDataButton[$iButtonIDEdit][$CST_SHELL_FILENAME])
		GUICtrlSetData($iShellParameters, $aDataButton[$iButtonIDEdit][$CST_SHELL_PARAMETERS])
		GUICtrlSetData($iShellWorkingdir, $aDataButton[$iButtonIDEdit][$CST_SHELL_WORKINGDIR])
		GUICtrlSetData($iScriptPath, $aDataButton[$iButtonIDEdit][$CST_SCRIPT_PATH])
	Else
		GUICtrlSetData($iButtonHint, "")
		GUICtrlSetData($iButtonIcon, "")
		GUICtrlSetState($rRun, $GUI_CHECKED)
		GUICtrlSetState($rShellExecute, $GUI_UNCHECKED)
		GUICtrlSetState($rCustomScript, $GUI_UNCHECKED)
		GUICtrlSetData($iRunProgram, "")
		GUICtrlSetData($iRunWorkingdir, "")
		GUICtrlSetData($iShellFilename, "")
		GUICtrlSetData($iShellParameters, "")
		GUICtrlSetData($iShellWorkingdir, "")
		GUICtrlSetData($iScriptPath, "")
	EndIf
	rClick()
	GUISetState(@SW_SHOW, $fButtonSettings)
EndFunc   ;==>__LoadButtonSettings
Func __LoadButtons()
	__Log("__LoadButtons")
	If FileExists($sPathButtons) Then
		_FileReadToArray($sPathButtons, $aDataButton, $FRTA_NOCOUNT, "|")
	EndIf
	__ResizeArray()
	__RefreshButtons()
EndFunc   ;==>__LoadButtons
Func __LoadIni()
	__Log("LoadIni")
	GUICtrlSetData($iCol, IniRead($sPathIni, "AutoIt_Launcher_Global_Settings", "iCol", 1))
	GUICtrlSetData($iRow, IniRead($sPathIni, "AutoIt_Launcher_Global_Settings", "iRow", 1))
	GUICtrlSetState($cbLog, IniRead($sPathIni, "AutoIt_Launcher_Global_Settings", "cbLog", $GUI_UNCHECKED))
EndFunc   ;==>__LoadIni
Func __Log($sToLog)
	ConsoleWrite(_NowCalc() & " : " & $sToLog & @CRLF)
	If GUICtrlRead($cbLog) = $GUI_CHECKED Then
		_FileWriteLog($sPathLog, $sToLog & @CRLF)
	EndIf
EndFunc   ;==>__Log
Func __onChange()
	__Log("__onChange")
	$bEdit = True
EndFunc   ;==>__onChange
Func __OnDrag()
	__Log("__OnDrag")
	Local $buttonDrag = -1
	Local $buttonDrop = -1
	Local $buttonID = 0
	; If the mouse button is pressed - get info about where
	Local $cInfo = GUIGetCursorInfo($fAutoItLauncher)
	; Is it over a button
	For $y = 0 To UBound($aListButton) - 1 Step 1
		For $x = 0 To UBound($aListButton, 2) - 1 Step 1
			$buttonID = $y * UBound($aListButton, 2) + $x
			If $cInfo[4] = $aListButton[$y][$x] Then
				$buttonDrag = $buttonID
				ExitLoop
			EndIf
		Next
	Next
	If $buttonDrag <> -1 Then
		; And then until the mouse button is released
		Do
			$cInfo = GUIGetCursorInfo($fAutoItLauncher)
		Until Not $cInfo[2]
		; See if the mouse was released over another button
		For $y = 0 To UBound($aListButton) - 1 Step 1
			For $x = 0 To UBound($aListButton, 2) - 1 Step 1
				$buttonID = $y * UBound($aListButton, 2) + $x
				If $cInfo[4] = $aListButton[$y][$x] Then
					$buttonDrop = $buttonID
					ExitLoop
				EndIf
			Next
		Next
	EndIf
	If $buttonDrop <> -1 And $buttonDrag <> $buttonDrop Then
		_ArraySwap($aDataButton, $buttonDrag, $buttonDrop)
		__SaveButtons()
		__RefreshButtons()
	EndIf
EndFunc   ;==>__OnDrag
Func __onDrop()
	__Log("__onDrop [DragId: " & @GUI_DragId & @CRLF & "DropId: " & @GUI_DropId & @CRLF & "DragFile: " & @GUI_DragFile & "]")
	If @GUI_DragId = -1 Then
		__onChange()
		Local $sPath = @GUI_DragFile
		Local $sExtension = __GetExtension($sPath)
		If @GUI_DropId = $iButtonIcon Then
			If $sExtension = ".ico" Then
				GUICtrlSetData($iButtonIcon, StringReplace($sPath, @ScriptDir & "\", ""))
			Else
				If $iButtonIDEdit <= UBound($aDataButton, 1) And $CST_SCRIPT_PATH + 1 = UBound($aDataButton, 2) Then
					GUICtrlSetData($iButtonIcon, $aDataButton[$iButtonIDEdit][$CST_ICON])
				Else
					GUICtrlSetData($iButtonIcon, "")
				EndIf
				MsgBox($MB_ICONWARNING, "Wrong file extension", "The expected file extension is .ico but your file is " & $sExtension)
			EndIf
		ElseIf @GUI_DropId = $iRunProgram Or @GUI_DropId = $iRunWorkingdir Then
			If $sExtension = ".exe" Then
				GUICtrlSetData($iRunProgram, StringReplace($sPath, @ScriptDir & "\", ""))
				GUICtrlSetData($iRunWorkingdir, StringReplace(__GetPath($sPath), @ScriptDir & "\", ""))
			Else
				If $iButtonIDEdit <= UBound($aDataButton, 1) And $CST_SCRIPT_PATH + 1 = UBound($aDataButton, 2) Then
					GUICtrlSetData($iRunProgram, $aDataButton[$iButtonIDEdit][$CST_RUN_PROGRAM])
					GUICtrlSetData($iRunWorkingdir, $aDataButton[$iButtonIDEdit][$CST_RUN_WORKINGDIR])
				Else
					GUICtrlSetData($iRunProgram, "")
					GUICtrlSetData($iRunWorkingdir, "")
				EndIf
				MsgBox($MB_ICONWARNING, "Wrong file extension", "The expected file extension is .exe but your file is " & $sExtension)
			EndIf
		ElseIf @GUI_DropId = $iShellFilename Or @GUI_DropId = $iShellWorkingdir Then
			Local $aTmp = [".sh", ".bat"]
			If _ArraySearch($aTmp, $sExtension) <> -1 Then
				GUICtrlSetData($iShellFilename, StringReplace($sPath, @ScriptDir & "\", ""))
				GUICtrlSetData($iShellWorkingdir, StringReplace(__GetPath($sPath), @ScriptDir & "\", ""))
			Else
				If $iButtonIDEdit <= UBound($aDataButton, 1) And $CST_SCRIPT_PATH + 1 = UBound($aDataButton, 2) Then
					GUICtrlSetData($iShellFilename, $aDataButton[$iButtonIDEdit][$CST_SHELL_FILENAME])
					GUICtrlSetData($iShellWorkingdir, $aDataButton[$iButtonIDEdit][$CST_SHELL_WORKINGDIR])
				Else
					GUICtrlSetData($iShellFilename, "")
					GUICtrlSetData($iShellWorkingdir, "")
				EndIf
				MsgBox($MB_ICONWARNING, "Wrong file extension", "The expected file extension is .sh or .bat but your file is " & $sExtension)
			EndIf
		ElseIf @GUI_DropId = $iScriptPath Then
			Local $aTmp = [".a3x", ".au3"]
			If _ArraySearch($aTmp, $sExtension) <> -1 Then
				GUICtrlSetData($iScriptPath, StringReplace($sPath, @ScriptDir & "\", ""))
			Else
				If $iButtonIDEdit <= UBound($aDataButton, 1) And $CST_SCRIPT_PATH + 1 = UBound($aDataButton, 2) Then
					GUICtrlSetData($iScriptPath, $aDataButton[$iButtonIDEdit][$CST_SCRIPT_PATH])
				Else
					GUICtrlSetData($iScriptPath, "")
				EndIf
				MsgBox($MB_ICONWARNING, "Wrong file extension", "The expected file extension is .a3x or .au3 but your file is " & $sExtension)
			EndIf
		EndIf
	EndIf
EndFunc   ;==>__onDrop
Func __RefreshButtons()
	__Log("__RefreshButtons")
	__Resize()
	__RemoveAllButtons()
	Local $buttonID = 0
	For $y = 0 To UBound($aListButton) - 1 Step 1
		For $x = 0 To UBound($aListButton, 2) - 1 Step 1
			$buttonID = $y * UBound($aListButton, 2) + $x
			$aListButton[$y][$x] = GUICtrlCreateButton("", 8 + (48 + 4) * $x, 8 + (48 + 4) * $y, 48, 48, $BS_ICON)
			GUICtrlSetOnEvent(-1, "bClick")
			If $buttonID < UBound($aDataButton) And $CST_MODE < UBound($aDataButton, 2) And $aDataButton[$buttonID][$CST_MODE] <> "" Then
				GUICtrlSetTip(-1, $aDataButton[$buttonID][$CST_HINT])
				GUICtrlSetImage(-1, $aDataButton[$buttonID][$CST_ICON])
			Else
				GUICtrlSetTip(-1, "Right click to edit button")
			EndIf
		Next
	Next
EndFunc   ;==>__RefreshButtons
Func __RemoveAllButtons()
	__Log("__RemoveAllButtons")
	For $y = 0 To UBound($aListButton) - 1 Step 1
		For $x = 0 To UBound($aListButton, 2) - 1 Step 1
			GUICtrlDelete($aListButton[$y][$x])
		Next
	Next
EndFunc   ;==>__RemoveAllButtons
Func __Resize()
	__Log("__Resize")
	Local $width = 16 + (48 + 4) * GUICtrlRead($iCol)
	Local $x = (@DesktopWidth / 2) - ($width / 2)
	Local $height = 25 + 16 + (48 + 4) * GUICtrlRead($iRow)
	Local $y = (@DesktopHeight / 2) - ($height / 2)
	Return WinMove($fAutoItLauncher, "AutoIt Launcher", $x, $y, $width, $height)
EndFunc   ;==>__Resize
Func __ResizeArray()
	__Log("__ResizeArray")
	ReDim $aListButton[GUICtrlRead($iRow)][GUICtrlRead($iCol)]
	Local $maxButtonID = GUICtrlRead($iRow) * GUICtrlRead($iCol)
	If $maxButtonID > UBound($aDataButton) Then
		ReDim $aDataButton[$maxButtonID][$CST_SCRIPT_PATH + 1]
	EndIf
EndFunc   ;==>__ResizeArray
;~ https://www.autoitscript.com/forum/topic/135203-call-another-script/?do=findComment&comment=943199
Func __RunAU3($sFilePath, $sWorkingDir = "", $iShowFlag = @SW_SHOW, $iOptFlag = 0)
	__Log("__RunAU3(" & $sFilePath & ", " & $sWorkingDir & ", " & $iShowFlag & ", " & $iOptFlag & ")")
	Return Run('"' & @AutoItExe & '" /AutoIt3ExecuteScript "' & $sFilePath & '"', $sWorkingDir, $iShowFlag, $iOptFlag)
EndFunc   ;==>__RunAU3
Func __SaveButtons()
	__Log("__SaveButtons")
	_FileWriteFromArray($sPathButtons, $aDataButton)
	__RefreshButtons()
EndFunc   ;==>__SaveButtons
Func __SaveIni()
	__Log("__SaveIni")
	IniWrite($sPathIni, "AutoIt_Launcher_Global_Settings", "iCol", GUICtrlRead($iCol))
	IniWrite($sPathIni, "AutoIt_Launcher_Global_Settings", "iRow", GUICtrlRead($iRow))
	IniWrite($sPathIni, "AutoIt_Launcher_Global_Settings", "cbLog", GUICtrlRead($cbLog))
EndFunc   ;==>__SaveIni
Func __SetEnableButtonSettings($lbRun = $GUI_DISABLE, $lbShell = $GUI_DISABLE, $lbScript = $GUI_DISABLE)
	__Log("__SetEnableButtonSettings(" & $lbRun & "," & $lbShell & "," & $lbScript & ")")
;~ 	Run
	GUICtrlSetState($iRunProgram, $lbRun)
	GUICtrlSetState($iRunWorkingdir, $lbRun)
;~ 	ShellExecute
	GUICtrlSetState($iShellFilename, $lbShell)
	GUICtrlSetState($iShellParameters, $lbShell)
	GUICtrlSetState($iShellWorkingdir, $lbShell)
;~ 	Script
	GUICtrlSetState($iScriptPath, $lbScript)
	GUICtrlSetState($bScriptPath, $lbScript)
EndFunc   ;==>__SetEnableButtonSettings
Func __Show()
	__Log("__Show")
	If Not __GUIVisible() Then GUISetState(@SW_SHOW, $fAutoItLauncher)
EndFunc   ;==>__Show
Func __ShowGlobalSettings()
	__Log("__ShowGlobalSettings")
	If Not __GUIVisible() Then GUISetState(@SW_SHOW, $fGlobalSettings)
EndFunc   ;==>__ShowGlobalSettings

Func bClick()
	__Log("bClick")
	__BtnClick(@GUI_CtrlId)
EndFunc   ;==>bClick
Func bIconClick()
	__Log("bIconClick")
	Local $sFileOpenDialog = FileOpenDialog("Open File", @ScriptDir & "\icons\", "Images (*.png;*.jpg;*.ico;*.bmp)", $FD_FILEMUSTEXIST)
	If @error Then
		FileChangeDir(@ScriptDir)
	Else
		FileChangeDir(@ScriptDir)
		GUICtrlSetData($iButtonIcon, StringReplace($sFileOpenDialog, @ScriptDir & "\", ""))
	EndIf
EndFunc   ;==>bIconClick
Func bSaveButtonClick()
	__Log("bSaveButtonClick")
	$bEdit = False
	$aDataButton[$iButtonIDEdit][$CST_HINT] = GUICtrlRead($iButtonHint)
	$aDataButton[$iButtonIDEdit][$CST_ICON] = GUICtrlRead($iButtonIcon)
	If GUICtrlRead($rRun) = $GUI_CHECKED Then
		$aDataButton[$iButtonIDEdit][$CST_MODE] = $CST_RUN
	ElseIf GUICtrlRead($rShellExecute) = $GUI_CHECKED Then
		$aDataButton[$iButtonIDEdit][$CST_MODE] = $CST_SHELLEXECUTE
	ElseIf GUICtrlRead($rCustomScript) = $GUI_CHECKED Then
		$aDataButton[$iButtonIDEdit][$CST_MODE] = $CST_SCRIPT
	EndIf
	$aDataButton[$iButtonIDEdit][$CST_RUN_PROGRAM] = GUICtrlRead($iRunProgram)
	$aDataButton[$iButtonIDEdit][$CST_RUN_WORKINGDIR] = GUICtrlRead($iRunWorkingdir)
	$aDataButton[$iButtonIDEdit][$CST_SHELL_FILENAME] = GUICtrlRead($iShellFilename)
	$aDataButton[$iButtonIDEdit][$CST_SHELL_PARAMETERS] = GUICtrlRead($iShellParameters)
	$aDataButton[$iButtonIDEdit][$CST_SHELL_WORKINGDIR] = GUICtrlRead($iShellWorkingdir)
	$aDataButton[$iButtonIDEdit][$CST_SCRIPT_PATH] = GUICtrlRead($iScriptPath)
	__SaveButtons()
	$iButtonIDEdit = -1
	GUISetState(@SW_HIDE, $fButtonSettings)
	__Show()
	__RefreshButtons()
EndFunc   ;==>bSaveButtonClick
Func bSaveSettingsClick()
	__Log("bSaveSettingsClick")
	$bEdit = False
	__SaveIni()
	GUISetState(@SW_HIDE, $fGlobalSettings)
	__Show()
	__LoadButtons()
EndFunc   ;==>bSaveSettingsClick
Func bScriptPathClick()
	__Log("bScriptPathClick")
	Local $sFileOpenDialog = FileOpenDialog("Open File", @ScriptDir & "\scripts\", "AutoIt (*.a3x;*.au3)", $FD_FILEMUSTEXIST)
	If @error Then
		FileChangeDir(@ScriptDir)
	Else
		FileChangeDir(@ScriptDir)
		GUICtrlSetData($iScriptPath, StringReplace($sFileOpenDialog, @ScriptDir & "\", ""))
	EndIf
EndFunc   ;==>bScriptPathClick
Func fAutoItLauncherClose()
	__Log("fAutoItLauncherClose")
	GUISetState(@SW_HIDE, $fAutoItLauncher)
EndFunc   ;==>fAutoItLauncherClose
;~ https://www.autoitscript.com/forum/topic/74079-check-for-right-click/?do=findComment&comment=1277537
Func fAutoItLauncherSecondaryUp()
	__Log("fAutoItLauncherSecondaryUp")
	Local $cInfo = GUIGetCursorInfo($fAutoItLauncher)
	__BtnClick($cInfo[4], False)
EndFunc   ;==>fAutoItLauncherSecondaryUp
Func fGlobalSettingsClose()
	__Log("fGlobalSettingsClose")
	If $bEdit Then
		If MsgBox($MB_YESNO, "Save", "Save changes?") = $IDYES Then
			bSaveSettingsClick()
		Else
			__LoadIni()
		EndIf
	EndIf
	GUISetState(@SW_HIDE, $fGlobalSettings)
	__Show()
EndFunc   ;==>fGlobalSettingsClose
Func fButtonSettingsClose()
	__Log("fButtonSettingsClose")
	If $bEdit Then
		If MsgBox($MB_YESNO, "Save", "Save changes?") = $IDYES Then
			bSaveButtonClick()
		EndIf
	EndIf
	GUISetState(@SW_HIDE, $fButtonSettings)
	__Show()
EndFunc   ;==>fButtonSettingsClose
Func rClick()
	__Log("rClick")
	If GUICtrlRead($rRun) = $GUI_CHECKED Then
		__SetEnableButtonSettings($GUI_ENABLE, $GUI_DISABLE, $GUI_DISABLE)
	ElseIf GUICtrlRead($rShellExecute) = $GUI_CHECKED Then
		__SetEnableButtonSettings($GUI_DISABLE, $GUI_ENABLE, $GUI_DISABLE)
	Else
		__SetEnableButtonSettings($GUI_DISABLE, $GUI_DISABLE, $GUI_ENABLE)
	EndIf
EndFunc   ;==>rClick
