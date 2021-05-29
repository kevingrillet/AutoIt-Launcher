#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         kevingrillet

 Script Function:
  	Launch BS & AFKDaily

#ce ----------------------------------------------------------------------------

Func __RunIfNotRunning($process, $exe, $dir = "", $time = 0)
	If Not ProcessExists($process) Then
		Run($exe, $dir)
		Sleep($time * 1000) ; s
	EndIf
EndFunc   ;==>__RunIfNotRunning

__RunIfNotRunning("Bluestacks.exe", "C:\Program Files\BlueStacks\Bluestacks.exe", "C:\Program Files\BlueStacks\", 30)
ShellExecute("deploy.sh", "-o .history/" & @YEAR & @MON & @MDAY & ".log", "D:\Users\kevin\Documents\GitHub\AFK-Daily-fork")
