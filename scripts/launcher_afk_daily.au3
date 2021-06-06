#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         kevingrillet

 Script Function:
  	Launch BS & AFKDaily

#ce ----------------------------------------------------------------------------

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_type=a3x
#AutoIt3Wrapper_Icon=..\icons\x48\afk_arena.ico
#AutoIt3Wrapper_Outfile=launcher_afk_daily.a3x
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

Func __ProcessClose($process)
	While ProcessExists($process)
		ProcessClose($process)
	WEnd
EndFunc   ;==>__ProcessClose

Func __RunIfNotRunning($process, $exe, $dir = "", $time = 0)
	If Not ProcessExists($process) Then
		Run($exe, $dir)
		Sleep($time * 1000) ; s
	EndIf
EndFunc   ;==>__RunIfNotRunning

__RunIfNotRunning("Bluestacks.exe", "C:\Program Files\BlueStacks\Bluestacks.exe", "C:\Program Files\BlueStacks\", 30)
ShellExecuteWait("deploy.sh", "-o .history/" & @YEAR & @MON & @MDAY & ".log", "D:\Users\kevin\Documents\GitHub\AFK-Daily")
Sleep(1 * 1000) ; s
__ProcessClose("adb.exe")
__ProcessClose("Bluestacks.exe")
