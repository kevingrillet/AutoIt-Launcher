#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         kevingrillet

 Script Function:
	Launch downloaders.

#ce ----------------------------------------------------------------------------

Func __RunIfNotRunning($process, $exe, $dir = "", $time = 0)
	If Not ProcessExists($process) Then
		Run($exe, $dir)
		Sleep($time * 1000) ; s
	EndIf
EndFunc   ;==>__RunIfNotRunning

__RunIfNotRunning("JDownloader2.exe", "C:\Users\kevin\AppData\Local\JDownloader 2.0\JDownloader2.exe")
__RunIfNotRunning("DownloaderForReddit.exe", "D:\Users\kevin\Downloads\Applications\_DownloaderForReddit\DownloaderForReddit.exe")
