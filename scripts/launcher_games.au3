#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         kevingrillet

 Script Function:
	Launch game launchers.

#ce ----------------------------------------------------------------------------

Func __RunIfNotRunning($process, $exe, $dir = "", $time = 0)
	If Not ProcessExists($process) Then
		Run($exe, $dir)
		Sleep($time * 1000) ; s
	EndIf
EndFunc   ;==>__RunIfNotRunning

__RunIfNotRunning("Battle.net.exe", "C:\Program Files (x86)\Battle.net\Battle.net Launcher.exe")
__RunIfNotRunning("EpicGamesLauncher.exe", "C:\Program Files (x86)\Epic Games\Launcher\Portal\Binaries\Win32\EpicGamesLauncher.exe")
__RunIfNotRunning("GalaxyClient.exe", "C:\Program Files (x86)\GOG Galaxy\GalaxyClient.exe")
__RunIfNotRunning("steam.exe", "C:\Program Files (x86)\Steam\steam.exe")
__RunIfNotRunning("upc.exe", "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\Uplay.exe")
