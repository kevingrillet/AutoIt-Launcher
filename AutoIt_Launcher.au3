#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         kevingrillet

 Script Function:
	Small launcher.

 ToDo:
	Change order of buttons
		Drag & Drop
			https://www.autoitscript.fr/forum/viewtopic.php?t=14808
			https://www.autoitscript.fr/autoit3/docs/functions/GUICtrlSetState.htm
				GUICtrlSetState(-1, $GUI_DROPACCEPTED)
				GUISetOnEvent($GUI_EVENT_DROPPED, "fAutoItLauncherDropped")
		Array swap
			https://www.autoitscript.com/autoit3/docs/libfunctions/_ArraySwap.htm

#ce ----------------------------------------------------------------------------

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icons\launcher.ico
#AutoIt3Wrapper_Outfile=Build\AutoIt_Launcher.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Description=Small launcher
#AutoIt3Wrapper_Res_Fileversion=0.0.0.1
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

#Region ### INCLUDES ###
#include <Array.au3>
#include <ButtonConstants.au3>
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
Opt("TrayAutoPause", 0) ;0=no pause, 1=Pause
Opt("TrayMenuMode", 3) ;0=append, 1=no default menu, 2=no automatic check, 4=menuitemID  not return
Opt("TrayOnEventMode", 1) ;0=disable, 1=enable
#EndRegion ### OPT ###

#Region ### START Koda GUI section ### Form=d:\users\kevin\documents\github\autoit-launcher\forms\fglobalsettings.kxf
$fGlobalSettings = GUICreate("Global Settings", 158, 157, -1, -1, $WS_SYSMENU)
GUISetOnEvent($GUI_EVENT_CLOSE, "fGlobalSettingsClose")
$lCols = GUICtrlCreateLabel("Columns", 8, 43, 44, 17)
$lRow = GUICtrlCreateLabel("Row", 8, 11, 26, 17)
$iRow = GUICtrlCreateInput("1", 56, 8, 89, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_RIGHT, $ES_NUMBER))
GUICtrlSetOnEvent(-1, "__onChange")
$iCol = GUICtrlCreateInput("1", 56, 40, 89, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_RIGHT, $ES_NUMBER))
GUICtrlSetOnEvent(-1, "__onChange")
$cbLog = GUICtrlCreateCheckbox("Save log", 8, 72, 97, 17)
GUICtrlSetOnEvent(-1, "__onChange")
$bSaveSettings = GUICtrlCreateButton("Save Global Settings", 8, 96, 139, 25)
GUICtrlSetOnEvent(-1, "bSaveSettingsClick")
;~ GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

#Region ### START Koda GUI section ### Form=d:\users\kevin\documents\github\autoit-launcher\forms\fbuttonsettings.kxf
$fButtonSettings = GUICreate("Button Settings", 498, 431, -1, -1, $WS_SYSMENU)
GUISetOnEvent($GUI_EVENT_CLOSE, "fButtonSettingsClose")
$lButtonHint = GUICtrlCreateLabel("Button Hint", 16, 19, 57, 17)
$iButtonHint = GUICtrlCreateInput("", 104, 16, 369, 21)
GUICtrlSetOnEvent(-1, "__onChange")
$lButtonIcon = GUICtrlCreateLabel("Icon", 16, 51, 25, 17)
$iButtonIcon = GUICtrlCreateInput("", 104, 48, 289, 21)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
GUICtrlSetOnEvent(-1, "__onChange")
$bIcon = GUICtrlCreateButton("Open", 400, 47, 74, 23)
GUICtrlSetOnEvent(-1, "bIconClick")
$gGroupSettings = GUICtrlCreateGroup("", 8, 80, 473, 281)
$rRun = GUICtrlCreateRadio("Run", 16, 96, 113, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetOnEvent(-1, "rClick")
$rCustomScript = GUICtrlCreateRadio("Custom Script", 16, 304, 113, 17)
GUICtrlSetOnEvent(-1, "rClick")
$lRunProgram = GUICtrlCreateLabel("Program", 32, 123, 43, 17)
$iRunProgram = GUICtrlCreateInput("", 104, 120, 369, 21)
GUICtrlSetOnEvent(-1, "__onChange")
$lRunWorkingdir = GUICtrlCreateLabel("Working Dir.", 32, 155, 63, 17)
$iRunWorkingdir = GUICtrlCreateInput("", 104, 152, 369, 21)
GUICtrlSetOnEvent(-1, "__onChange")
$rShellExecute = GUICtrlCreateRadio("ShellExecute", 16, 184, 113, 17)
GUICtrlSetOnEvent(-1, "rClick")
$lShellFilename = GUICtrlCreateLabel("Filename", 32, 211, 46, 17)
$iShellFilename = GUICtrlCreateInput("", 104, 208, 369, 21)
GUICtrlSetOnEvent(-1, "__onChange")
$lShellParameters = GUICtrlCreateLabel("Parameters", 32, 243, 57, 17)
$iShellWorkingdir = GUICtrlCreateInput("", 104, 272, 369, 21)
GUICtrlSetOnEvent(-1, "__onChange")
$lShellWorkingdir = GUICtrlCreateLabel("Working Dir.", 32, 275, 63, 17)
$iShellParameters = GUICtrlCreateInput("", 104, 240, 369, 21)
GUICtrlSetOnEvent(-1, "__onChange")
$lScriptPath = GUICtrlCreateLabel("Path", 32, 331, 26, 17)
$iScriptPath = GUICtrlCreateInput("", 104, 328, 289, 21)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
GUICtrlSetOnEvent(-1, "__onChange")
$bScriptPath = GUICtrlCreateButton("Open", 400, 327, 74, 23)
GUICtrlSetOnEvent(-1, "bScriptPathClick")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$bSaveButton = GUICtrlCreateButton("Save", 7, 368, 475, 25)
GUICtrlSetOnEvent(-1, "bSaveButtonClick")
GUISetOnEvent($GUI_EVENT_DROPPED, "__onDrop")
;~ GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

#Region ### START Koda GUI section ### Form=d:\users\kevin\documents\github\autoit-launcher\forms\fautoitlauncher.kxf
$fAutoItLauncher = GUICreate("AutoIt Launcher", 615, 437, -1, -1, $WS_SYSMENU)
GUISetOnEvent($GUI_EVENT_CLOSE, "fAutoItLauncherClose")
GUISetOnEvent($GUI_EVENT_SECONDARYUP, "fAutoItLauncherSecondaryUp")
;~ GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


#Region ### TrayIcon ###
$miShow = TrayCreateItem("Show AutoIt Launcher")
TrayItemSetOnEvent(-1, "__Show")
$miShowSettings = TrayCreateItem("Show Global Settings")
TrayItemSetOnEvent(-1, "__ShowGlobalSettings")
$miShutDown = TrayCreateItem("Shut Down AutoIt Launcher")
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
	Local $buttonID = 0
	For $y = 0 To GUICtrlRead($iRow) - 1 Step 1
		For $x = 0 To GUICtrlRead($iCol) - 1 Step 1
			If $aListButton[$y][$x] = $CtrlId Then
				$buttonID = $y * GUICtrlRead($iCol) + $x
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
	__SaveIni()
	__Log("Exiting")
	Exit
EndFunc   ;==>__Exit
Func __GUIVisible()
	Local $res = False
	If WinGetState($fAutoItLauncher) = $WIN_STATE_VISIBLE Then $res = True
	If WinGetState($fGlobalSettings) = $WIN_STATE_VISIBLE Then $res = True
	If WinGetState($fButtonSettings) = $WIN_STATE_VISIBLE Then $res = True
	Return $res
EndFunc   ;==>__GUIVisible
Func __LoadButtonSettings($buttonID)
	$iButtonIDEdit = $buttonID
	GUISetState(@SW_HIDE, $fAutoItLauncher)
	If $iButtonIDEdit <= UBound($aDataButton, 1) And $CST_SCRIPT_PATH + 1 = UBound($aDataButton, 2) Then
		GUICtrlSetData($iButtonHint, $aDataButton[$iButtonIDEdit][$CST_HINT])
		GUICtrlSetData($iButtonIcon, $aDataButton[$iButtonIDEdit][$CST_ICON])
		Switch $aDataButton[$iButtonIDEdit][$CST_MODE]
			Case $CST_RUN
				GUICtrlSetState($rRun, $GUI_CHECKED)
			Case $CST_SHELLEXECUTE
				GUICtrlSetState($rShellExecute, $GUI_CHECKED)
			Case $CST_SCRIPT
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
	If GUICtrlRead($cbLog) = $GUI_CHECKED Then
		_FileWriteLog($sPathLog, $sToLog & @CRLF)
	EndIf
EndFunc   ;==>__Log
Func __onChange()
	$bEdit = True
EndFunc   ;==>__onChange
;~ https://www.autoitscript.com/autoit3/docs/functions/GUISetOnEvent.htm
Func __onDrop()
	If @GUI_DropId = $iButtonIcon Then
		GUICtrlSetData($iButtonIcon, StringReplace(@GUI_DragFile, @ScriptDir & "\", ""))
	ElseIf @GUI_DropId = $iScriptPath Then
		GUICtrlSetData($iScriptPath, StringReplace(@GUI_DragFile, @ScriptDir & "\", ""))
	EndIf
EndFunc   ;==>__onDrop
Func __RefreshButtons()
	__Resize()
	__RemoveAllButtons()
	Local $buttonID = 0
	For $y = 0 To GUICtrlRead($iRow) - 1 Step 1
		For $x = 0 To GUICtrlRead($iCol) - 1 Step 1
			$buttonID = $y * GUICtrlRead($iCol) + $x
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
	For $y = 0 To UBound($aListButton, 1) - 1 Step 1
		For $x = 0 To UBound($aListButton, 2) - 1 Step 1
			GUICtrlDelete($aListButton[$y][$x])
		Next
	Next
EndFunc   ;==>__RemoveAllButtons
Func __Resize()
	Local $width = 16 + (48 + 4) * GUICtrlRead($iCol)
	Local $x = (@DesktopWidth / 2) - ($width / 2)
	Local $height = 25 + 16 + (48 + 4) * GUICtrlRead($iRow)
	Local $y = (@DesktopHeight / 2) - ($height / 2)
	Return WinMove($fAutoItLauncher, "AutoIt Launcher", $x, $y, $width, $height)
EndFunc   ;==>__Resize
Func __ResizeArray()
	ReDim $aListButton[GUICtrlRead($iRow) + 1][GUICtrlRead($iCol) + 1]
	Local $maxButtonID = GUICtrlRead($iRow) * GUICtrlRead($iCol)
	If $maxButtonID > UBound($aDataButton) Then
		ReDim $aDataButton[$maxButtonID][$CST_SCRIPT_PATH + 1]
	EndIf
EndFunc   ;==>__ResizeArray
;~ https://www.autoitscript.com/forum/topic/135203-call-another-script/?do=findComment&comment=943199
Func __RunAU3($sFilePath, $sWorkingDir = "", $iShowFlag = @SW_SHOW, $iOptFlag = 0)
	Return Run('"' & $sFilePath & '"', $sWorkingDir, $iShowFlag, $iOptFlag)
EndFunc   ;==>__RunAU3
Func __SaveButtons()
	_FileWriteFromArray($sPathButtons, $aDataButton)
	__RefreshButtons()
EndFunc   ;==>__SaveButtons
Func __SaveIni()
	__Log("SaveIni")
	IniWrite($sPathIni, "AutoIt_Launcher_Global_Settings", "iCol", GUICtrlRead($iCol))
	IniWrite($sPathIni, "AutoIt_Launcher_Global_Settings", "iRow", GUICtrlRead($iRow))
	IniWrite($sPathIni, "AutoIt_Launcher_Global_Settings", "cbLog", GUICtrlRead($cbLog))
EndFunc   ;==>__SaveIni
Func __SetEnableButtonSettings($lbRun = $GUI_DISABLE, $lbShell = $GUI_DISABLE, $lbScript = $GUI_DISABLE)
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
	If Not __GUIVisible() Then GUISetState(@SW_SHOW, $fAutoItLauncher)
EndFunc   ;==>__Show
Func __ShowGlobalSettings()
	If Not __GUIVisible() Then GUISetState(@SW_SHOW, $fGlobalSettings)
EndFunc   ;==>__ShowGlobalSettings

Func bClick()
	__BtnClick(@GUI_CtrlId)
EndFunc   ;==>bClick
Func bIconClick()
	Local $sFileOpenDialog = FileOpenDialog("Open File", @ScriptDir & "\icons\", "Images (*.png;*.jpg;*.ico;*.bmp)", $FD_FILEMUSTEXIST)
	If @error Then
		FileChangeDir(@ScriptDir)
	Else
		FileChangeDir(@ScriptDir)
		GUICtrlSetData($iButtonIcon, StringReplace($sFileOpenDialog, @ScriptDir & "\", ""))
	EndIf
EndFunc   ;==>bIconClick
Func bSaveButtonClick()
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
	$bEdit = False
	__SaveIni()
	GUISetState(@SW_HIDE, $fButtonSettings)
	__Show()
	__LoadButtons()
EndFunc   ;==>bSaveSettingsClick
Func bScriptPathClick()
	Local $sFileOpenDialog = FileOpenDialog("Open File", @ScriptDir & "\scripts\", "AutoIt (*.au3)", $FD_FILEMUSTEXIST)
	If @error Then
		FileChangeDir(@ScriptDir)
	Else
		FileChangeDir(@ScriptDir)
		GUICtrlSetData($iScriptPath, StringReplace($sFileOpenDialog, @ScriptDir & "\", ""))
	EndIf
EndFunc   ;==>bScriptPathClick
Func fAutoItLauncherClose()
	GUISetState(@SW_HIDE, $fAutoItLauncher)
EndFunc   ;==>fAutoItLauncherClose
;~ https://www.autoitscript.com/forum/topic/74079-check-for-right-click/?do=findComment&comment=1277537
Func fAutoItLauncherSecondaryUp()
	Local $cInfo = GUIGetCursorInfo($fAutoItLauncher)
	__BtnClick($cInfo[4], False)
EndFunc   ;==>fAutoItLauncherSecondaryUp
Func fGlobalSettingsClose()
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
	If $bEdit Then
		If MsgBox($MB_YESNO, "Save", "Save changes?") = $IDYES Then
			bSaveButtonClick()
		EndIf
	EndIf
	GUISetState(@SW_HIDE, $fButtonSettings)
	__Show()
EndFunc   ;==>fButtonSettingsClose
Func rClick()
	If GUICtrlRead($rRun) = $GUI_CHECKED Then
		__SetEnableButtonSettings($GUI_ENABLE, $GUI_DISABLE, $GUI_DISABLE)
	ElseIf GUICtrlRead($rShellExecute) = $GUI_CHECKED Then
		__SetEnableButtonSettings($GUI_DISABLE, $GUI_ENABLE, $GUI_DISABLE)
	Else
		__SetEnableButtonSettings($GUI_DISABLE, $GUI_DISABLE, $GUI_ENABLE)
	EndIf
EndFunc   ;==>rClick
