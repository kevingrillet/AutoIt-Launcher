#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         kevingrillet

 Script Function:
	Launch VDX & Remote Play.

#ce ----------------------------------------------------------------------------

Func __RunIfNotRunning($process, $exe, $dir = "", $time = 0)
	If Not ProcessExists($process) Then
		Run($exe, $dir)
		Sleep($time * 1000) ; s
	EndIf
EndFunc   ;==>__RunIfNotRunning

__RunIfNotRunning("VDX_x64.exe", "D:\Users\kevin\Toolbar\Jeux\PS4\_\VDX_v1.14.3.0_x64_x86_GPDWinEdition\VDX_x64.exe", "D:\Users\kevin\Toolbar\Jeux\PS4\_\VDX_v1.14.3.0_x64_x86_GPDWinEdition\", 1)
__RunIfNotRunning("RemotePlay.exe", "C:\Program Files (x86)\Sony\PS Remote Play\RemotePlay.exe", "C:\Program Files (x86)\Sony\PS Remote Play\")
