#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         kevingrillet

 Script Function:
	Launch VDX & Remote Play.

#ce ----------------------------------------------------------------------------

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_type=a3x
#AutoIt3Wrapper_Icon=..\icons\ps_remote_play.ico
#AutoIt3Wrapper_Outfile=launcher_PS4.a3x
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

__RunIfNotRunning("VDX_x64.exe", "D:\Users\kevin\Toolbar\Jeux\PS4\_\VDX_v1.14.3.0_x64_x86_GPDWinEdition\VDX_x64.exe", "D:\Users\kevin\Toolbar\Jeux\PS4\_\VDX_v1.14.3.0_x64_x86_GPDWinEdition\", 1)
__RunIfNotRunning("RemotePlay.exe", "C:\Program Files (x86)\Sony\PS Remote Play\RemotePlay.exe", "C:\Program Files (x86)\Sony\PS Remote Play\")
