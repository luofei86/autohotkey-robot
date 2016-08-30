;LoggerUtils.ahk
;static preAppendDate :=  % A_Now
;static filename := ""
writeLock := 0
;MsgBox % (A_WorkingDir)
;MsgBox % (_formatLogInfo("hHellO"))
;logInfo("AAA")
logError(loginfo)
{
	_logAppend(logInfo, "ERROR")
}

logDebug(loginfo)
{
	_logAppend(logInfo, "DEBUG")
}

logWarn(loginfo)
{
	_logAppend(logInfo, "WARN")
}

logInfo(loginfo)
{
	_logAppend(logInfo, "INFO")
}

_logAppend(logInfo, level := "INFO")
{
	global writeLock
	if writeLock = 0
	{
		writeLock := writeLock + 1
		if (writeLock != 1)
		{
			MsgBox "Cur lock is lock"
			Sleep 1000
			_logAppend(logInfo, level)
		}
	}else{
		Sleep 1000
		_logAppend(logInfo, level)
	}
	try{
		preAppendDate :=  % A_YYYY . A_MM . A_DD
		filename := "runlog." . preAppendDate . ".log"
		logPath := A_WorkingDir . "\" . filename
		logData := _formatLogInfo(logInfo, level)
		FileAppend, %logData%, %logPath%
		;FileAppend , `n , %logPath%
	}finally{
		writeLock := false
	}
}


_formatLogInfo(logInfo, level := "INFO")
{
	info := A_YYYY . "-" . A_MM . "-" . A_DD . " " . A_Hour . ":" . A_Min . ":" . A_Sec . "-" . level . "-" . loginfo . "`n"
	return info
}