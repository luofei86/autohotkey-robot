;机器相关类
;Name  MachineUtils.ahk
;MsgBox % GetMacAddress()

GetMacAddress(){
	tempfile = %A_Temp%\mac.txt
	RunWait, %ComSpec% /c getmac /NH > %tempfile%, , Hide ; ipconfig (slow)
	FileRead, thetext, %tempfile%
	RegExMatch(thetext, ".*?([0-9A-Z].{16})(?!\w\\Device)", mac)
	return mac1
}