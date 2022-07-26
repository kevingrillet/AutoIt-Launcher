#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         kevingrillet

 Script Function:
	Launch League & Blitz.

#ce ----------------------------------------------------------------------------

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_type=a3x
#AutoIt3Wrapper_Icon=..\icons\x48\league_of_legends.ico
#AutoIt3Wrapper_Outfile=launcher_lol.a3x
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

Opt("MustDeclareVars", 1) ;0=no, 1=require pre-declaration

Func __RunIfNotRunning($process, $exe, $dir = "", $time = 0)
	If Not ProcessExists($process) Then
		Run($exe, $dir)
		Sleep($time * 1000) ; s
	EndIf
EndFunc   ;==>__RunIfNotRunning

;~ __RunIfNotRunning("Blitz.exe", "C:\Users\kevin\AppData\Local\Programs\Blitz\Blitz.exe")
__RunIfNotRunning("OverwolfLauncher.exe", '"D:\Program Files (x86)\Overwolf\OverwolfLauncher.exe" -launchapp pibhbkkgefgheeglaeemkkfjlhidhcedalapdggh -from-startmenu')
__RunIfNotRunning("LeagueClientUx.exe", "D:\Program Files\Riot Games\League of Legends\LeagueClient.exe")
