#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         kevingrillet

 Script Function:
	Check if there is a new free game

#ce ----------------------------------------------------------------------------

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_type=a3x
#AutoIt3Wrapper_Icon=..\icons\EpicGamesStore.ico
#AutoIt3Wrapper_Outfile=check_EpicGames_Free.a3x
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Copyright (C) 2021
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Field=Compiler Date|%date%
#AutoIt3Wrapper_Res_Field=Compiler Heure|%time%
#AutoIt3Wrapper_Res_Field=Compiler Version|AutoIt v%AutoItVer%
#AutoIt3Wrapper_Res_Field=Author|kevingrillet
#AutoIt3Wrapper_Res_Field=Github|https://github.com/kevingrillet/AutoIt-Launcher
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <Date.au3>
Const $sPathIni = "check_EpicGames_Free.ini"
Local $sUntil = IniRead($sPathIni, "EpicGamesStore", "Until", (@YEAR - 1) & "/" & @MON & "/" & @MDAY)
$sUntil = StringReplace($sUntil, "-", "/")
$sUntil = StringSplit($sUntil, "T")[1]
If _DateDiff('D', $sUntil, @YEAR & "/" & @MON & "/" & @MDAY) < 0 Then
	ConsoleWrite("+Finished:: Nothing to do" & @CRLF)
	Exit 0
EndIf

;~ WebDriver UDF (W3C compliant version) - 04/28/2021
;~ https://www.autoitscript.com/forum/topic/191990-webdriver-udf-w3c-compliant-version-04282021/
#include "UDF/WebDriver/wd_core.au3"
#include "UDF/WebDriver/wd_helper.au3"
Local $sDesiredCapabilities, $sSession
$_WD_DEBUG = $_WD_DEBUG_None

__SetupEdge()
_WD_Startup()
$sSession = _WD_CreateSession($sDesiredCapabilities)

If @error = $_WD_ERROR_Success Then
	ConsoleWrite("+Running: __FindFreeNow" & @CRLF)
	$aData = __FindFreeNow()
	ConsoleWrite("+Finished: __FindFreeNow" & @CRLF)
EndIf

;~ MsgBox($MB_ICONINFORMATION, "Complete!", "Click ok to shutdown the browser and console")

_WD_DeleteSession($sSession)
_WD_Shutdown()

;~ 	_ArrayDisplay($aOutput)
If IniRead($sPathIni, "EpicGamesStore", "Title", "") <> $aData[0][0] Then
	IniWrite($sPathIni, "EpicGamesStore", "Title", $aData[0][0])
	IniWrite($sPathIni, "EpicGamesStore", "Until", $aData[0][1])
	MsgBox($MB_ICONINFORMATION, "Epic Games Store", "New free game to get!")
EndIf

Func __FindFreeNow()
	Local $sElement, $aOutput[1][2]

	_WD_Navigate($sSession, "https://www.epicgames.com/store/en-US/free-games?lang=en-US")

;~ 	Locate title for the Temporary Free Game
	$sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, "//span[@data-component='OfferTitleInfo']")
	$aOutput[0][0] = _WD_ElementAction($sSession, $sElement, 'Text')

;~ 	Finding time: 	Free Now - (Time)
	$sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, "//span[@data-component='OfferTitleInfo']/span[@data-component='Message']/time")
	$aOutput[0][1] = _WD_ElementAction($sSession, $sElement, 'Attribute', 'datetime')

	Return $aOutput
EndFunc   ;==>__FindFreeNow

Func __SetupEdge()
	_WD_Option('Driver', 'scripts\UDF\WebDriver\msedgedriver.exe')
	_WD_Option('Port', 9515)
	_WD_Option('DriverParams', '--verbose --log-path="' & @ScriptDir & '\msedge.log"')

	$sDesiredCapabilities = '{"capabilities": {"alwaysMatch": {"ms:edgeOptions": {"binary": "' & StringReplace(@ProgramFilesDir, "\", "/") & '/Microsoft/Edge/Application/msedge.exe", "excludeSwitches": [ "enable-automation"], "useAutomationExtension": false}}}}'
EndFunc   ;==>__SetupEdge

;~ Trash
;~ Not working on this website :/

;~ #include <IE.au3>
;~ #include <Array.au3>
;~ Local $oIE = _IECreate("https://www.epicgames.com/store/en-US/free-games?lang=en-US")
;~ Local $oLinks = _IELinkGetCollection($oIE)
;~ Local $aTmp[0][2]
;~ Local $sTxt
;~ For $oLink In $oLinks
;~ 	$sTxt &= $oLink.innertext & "|" & $oLink.href & @CRLF
;~ Next
;~ _ArrayAdd($aTmp, $sTxt)
;~ _ArrayDisplay($aTmp, "tous les liens")
;~ Local $sFreeGame
;~ For $i = 0 To UBound($aTmp) - 1
;~ 	If $aTmp[$i][0] = "Free Now" Then
;~ 		$sFreeGame &= $aTmp[$i][1] & @CRLF
;~ 		ExitLoop
;~ 	EndIf
;~ Next
;~ MsgBox(0, "", $sFreeGame)
;~ _IEQuit($oIE)

;~ #include <Inet.au3>
;~ Local $sURL = "https://www.epicgames.com/store/en-US/free-games?lang=en-US"
;~ Local $sResult = ""
;~ $sResult = _INetGetSource($sURL)
;~ $sResult = InetRead($sURL, $INET_FORCERELOAD)
;~ ConsoleWrite($sResult & @CRLF)
