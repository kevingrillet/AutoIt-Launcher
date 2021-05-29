#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         kevingrillet

 Script Function:
	Small launcher.

 ToDo:
	Add missing UI [./forms/fButtonSettings]
	Right click on button in [bButtonClick]
	Add button / data
		https://www.autoitscript.com/autoit3/docs/libfunctions/_ArrayInsert.htm
	Edit Button

	Change order of buttons?
	Test if it's working

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
Const $CST_ICON = 1
Const $CST_MODE = 2
Const $CST_RUN_PROGRAM = 3
Const $CST_RUN_WORKINGDIR = 4
Const $CST_SHELL_FILENAME = 5
Const $CST_SHELL_PARAMETERS = 6
Const $CST_SHELL_WORKINGDIR = 7
Const $CST_SCRIPT_PATH = 8
;~ Button mode
Const $CST_RUN = 0
Const $CST_SHELLEXECUTE = 1
Const $CST_SCRIPT = 2
#EndRegion ### CONSTANTS ###

#Region ### VARIABLES ###
Local $aListButton[0][0]
Local $aDataButton[0][0]
Local $sPathButtons = @ScriptDir & "\AutoIt_Launcher_buttons.txt"
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
$iCol = GUICtrlCreateInput("1", 56, 40, 89, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_RIGHT, $ES_NUMBER))
$bSaveSettings = GUICtrlCreateButton("Save Global Settings", 8, 96, 139, 25)
GUICtrlSetOnEvent($bSaveSettings, "bSaveSettingsClick")
$cbLog = GUICtrlCreateCheckbox("Save log", 8, 72, 97, 17)
#EndRegion ### END Koda GUI section ###

#Region ### START Koda GUI section ### Form=d:\users\kevin\documents\github\autoit-launcher\forms\fautoitlauncher.kxf
$fAutoItLauncher = GUICreate("AutoIt Launcher", 615, 437, -1, -1, $WS_SYSMENU)
GUISetOnEvent($GUI_EVENT_CLOSE, "fAutoItLauncherClose")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


#Region ### TrayIcon ###
$miShow = TrayCreateItem("Show AutoIt Launcher")
TrayItemSetOnEvent($miShow, "__Show")
$miShowSettings = TrayCreateItem("Show Global Settings")
TrayItemSetOnEvent($miShow, "__ShowGlobalSettings")
$miShutDown = TrayCreateItem("Shut Down AutoIt Launcher")
TrayItemSetOnEvent($miShutDown, "__Exit")
TraySetOnEvent($TRAY_EVENT_PRIMARYDOUBLE, "__Show")
TraySetToolTip("AutoIt Launcher")
#EndRegion ### TrayIcon ###

__Log("Starting")
__LoadIni()
If Not FileExists($sPathIni) Then
	__ShowGlobalSettings()
EndIf
__LoadButtons()

While 1
	Sleep(100)
WEnd

Func __Exit()
	__SaveIni()
	__Log("Exiting")
	Exit
EndFunc   ;==>__Exit
Func __LoadButtons()
	_FileReadToArray($sPathButtons, $aDataButton)
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
Func __RefreshButtons()
	__Resize()
	__RemoveAllButtons()
	Local $buttonID = 0
	For $y = 0 To GUICtrlRead($iRow) - 1 Step 1
		For $x = 0 To GUICtrlRead($iCol) - 1 Step 1
			$buttonID = $y * GUICtrlRead($iCol) + $x
			If $y >= UBound($aListButton, 1) Or $x >= UBound($aListButton, 2) Then
				_ArrayInsert($aListButton, $y & ";" & $x, GUICtrlCreateButton("Button_" & $y & "_" & $x, 8 + (48 + 4) * $x, 8 + (48 + 4) * $y, 48, 48, $BS_BITMAP))
			Else
				$aListButton[$y][$x] = GUICtrlCreateButton("Button_" & $y & "_" & $x, 8 + (48 + 4) * $x, 8 + (48 + 4) * $y, 48, 48, $BS_BITMAP)
			EndIf
			GUICtrlSetOnEvent(-1, "bButtonClick")
			If $buttonID < UBound($aDataButton, 1) Then
				GUICtrlSetTip(-1, $aDataButton[$buttonID][$CST_HINT])
				GUICtrlSetImage(-1, $aDataButton[$buttonID][$CST_ICON])
			EndIf
		Next
	Next
EndFunc   ;==>__RefreshButtons
Func __RemoveAllButtons()
	For $y = 0 To GUICtrlRead($iRow) - 1 Step 1
		If $y < UBound($aDataButton, 1) Then
			For $x = 0 To GUICtrlRead($iCol) - 1 Step 1
				If $x < UBound($aDataButton, 2) Then
					GUICtrlDelete($aListButton[$y][$x])
				EndIf
			Next
		EndIf
	Next
EndFunc   ;==>__RemoveAllButtons
Func __Resize()
	Local $width = 16 + (48 + 4) * GUICtrlRead($iCol)
	Local $x = (@DesktopWidth / 2) - ($width / 2)
	Local $height = 16 + (48 + 4) * GUICtrlRead($iRow)
	Local $y = (@DesktopHeight / 2) - ($height / 2)
	Return WinMove($fAutoItLauncher, "AutoIt Launcher", $x, $y, $width, $height)
EndFunc   ;==>__Resize
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
Func __Show()
	GUISetState(@SW_SHOW, $fAutoItLauncher)
EndFunc   ;==>__Show
Func __ShowGlobalSettings()
	GUISetState(@SW_SHOW, $fGlobalSettings)
EndFunc   ;==>__ShowGlobalSettings

Func bSaveSettingsClick()
	__SaveIni()
EndFunc   ;==>bSaveSettingsClick
Func bButtonClick()
	Local $buttonID = 0
	For $y = 0 To GUICtrlRead($iRow) - 1 Step 1
		For $x = 0 To GUICtrlRead($iCol) - 1 Step 1
			If $aListButton[$y][$x] = @GUI_CtrlId Then
				$buttonID = $y * GUICtrlRead($iCol) + $x
				Switch $aDataButton[$buttonID][$CST_MODE]
					Case $CST_RUN
						Run($aDataButton[$buttonID][$CST_RUN_PROGRAM], $aDataButton[$buttonID][$CST_RUN_WORKINGDIR])
					Case $CST_SHELLEXECUTE
						ShellExecute($aDataButton[$buttonID][$CST_SHELL_FILENAME], $aDataButton[$buttonID][$CST_SHELL_PARAMETERS], $aDataButton[$buttonID][$CST_SHELL_WORKINGDIR])
					Case $CST_SCRIPT
						__RunAU3($aDataButton[$buttonID][$CST_SCRIPT_PATH])
				EndSwitch
				ExitLoop
			EndIf
		Next
	Next
EndFunc   ;==>bButtonClick
Func fAutoItLauncherClose()
	GUISetState(@SW_HIDE, $fAutoItLauncher)
EndFunc   ;==>fAutoItLauncherClose
Func fGlobalSettingsClose()
	GUISetState(@SW_HIDE, $fGlobalSettings)
EndFunc   ;==>fGlobalSettingsClose
