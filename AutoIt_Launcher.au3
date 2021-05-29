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
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         kevingrillet

 Script Function:
	Small launcher.

#ce ----------------------------------------------------------------------------

;~ ========== INCLUDES ==========
#Region ### START INCLUDES ###
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <File.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#EndRegion ### START INCLUDES ###

;~ ========== VARIABLES ==========
#Region ### START VARIABLES ###
Local $sPathIni = @ScriptDir & "\AutoIt_Launcher.ini"
Local $sPathLog = @ScriptDir & "\AutoIt_Launcher.log"
#EndRegion ### START VARIABLES ###

;~ ========== OPT ==========
#Region ### START OPT ###
Opt("GUIOnEventMode", 1) ;0=disabled, 1=OnEvent mode enabled
Opt("TrayAutoPause", 0) ;0=no pause, 1=Pause
Opt("TrayMenuMode", 3) ;0=append, 1=no default menu, 2=no automatic check, 4=menuitemID  not return
Opt("TrayOnEventMode", 1) ;0=disable, 1=enable
#EndRegion ### START OPT ###

;~ ========== GUI ==========
#Region ### START Koda GUI section ### Form=d:\users\kevin\documents\github\autoit-launcher\forms\fglobalsettings.kxf
$fGlobalSettings = GUICreate("Global Settings", 158, 157, 192, 147, $WS_SYSMENU)
GUISetOnEvent($GUI_EVENT_CLOSE, "fGlobalSettingsClose")
$lCols = GUICtrlCreateLabel("Columns", 8, 43, 44, 17)
$lRow = GUICtrlCreateLabel("Row", 8, 11, 26, 17)
$iRow = GUICtrlCreateInput("1", 56, 8, 89, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_RIGHT, $ES_NUMBER))
$iCol = GUICtrlCreateInput("1", 56, 40, 89, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_RIGHT, $ES_NUMBER))
$bSaveSettings = GUICtrlCreateButton("Save Global Settings", 8, 96, 139, 25)
GUICtrlSetOnEvent($bSaveSettings, "bSaveSettingsClick")
$cbLog = GUICtrlCreateCheckbox("Save log", 8, 72, 97, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

#Region ### START TrayIcon ###
$miShow = TrayCreateItem("Show AutoIt Launcher")
TrayItemSetOnEvent($miShow, "__Show")
$miShowSettings = TrayCreateItem("Show Global Settings")
TrayItemSetOnEvent($miShow, "__ShowGlobalSettings")
$miShutDown = TrayCreateItem("Shut Down AutoIt Launcher")
TrayItemSetOnEvent($miShutDown, "__Exit")
TraySetToolTip("AutoIt Launcher")
#EndRegion ### START TrayIcon ###


__Log("Starting")
__LoadIni()
If Not FileExists($sPathIni) Then
	__ShowGlobalSettings
EndIf

While 1
	Sleep(100)
WEnd

Func __Exit()
	__SaveIni()
	__Log("Exiting")
	Exit
EndFunc   ;==>__Exit
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
Func __SaveIni()
	__Log("SaveIni")
	IniWrite($sPathIni, "AutoIt_Launcher_Global_Settings", "iCol", GUICtrlRead($iCol))
	IniWrite($sPathIni, "AutoIt_Launcher_Global_Settings", "iRow", GUICtrlRead($iRow))
	IniWrite($sPathIni, "AutoIt_Launcher_Global_Settings", "cbLog", GUICtrlRead($cbLog))
EndFunc   ;==>__SaveIni
Func __Show()
	;GUISetState(@SW_SHOW, $whLauncher)
EndFunc   ;==>__Show
Func __ShowGlobalSettings()
	GUISetState(@SW_SHOW, $fGlobalSettings)
EndFunc   ;==>__ShowGlobalSettings


Func bSaveSettingsClick()
	__SaveIni()
EndFunc   ;==>bSaveSettingsClick
Func fGlobalSettingsClose()
	GUISetState(@SW_HIDE, $fGlobalSettings)
EndFunc   ;==>fGlobalSettingsClose
