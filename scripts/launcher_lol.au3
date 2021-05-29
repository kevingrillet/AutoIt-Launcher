#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         kevingrillet

 Script Function:
	Launch League & Blitz.

#ce ----------------------------------------------------------------------------

Func __RunIfNotRunning($process, $exe, $dir = "", $time = 0)
	If Not ProcessExists($process) Then
		Run($exe, $dir)
		Sleep($time * 1000) ; s
	EndIf
EndFunc   ;==>__RunIfNotRunning

__RunIfNotRunning("Blitz.exe", "C:\Users\kevin\AppData\Local\Programs\Blitz\Blitz.exe")
__RunIfNotRunning("LeagueClientUx.exe", "D:\Program Files\Riot Games\League of Legends\LeagueClient.exe")
