;;;;server api handle
#Include MachineUtils.ahk
#Include LoggerUtils.ahk
#Include json\JSON.ahk

ServerApiStrRemoteTaskInfo(remoteTaskInfo)
{
	if remoteTaskInfo
	{
		
	}
}

;根据机器码来获取需要播放的视频信息,由服务器确保当前账号只分发给一台机器处理
ServerApiGetRemoteTaskInfo()
{
	macAddress := GetMacAddress()
	if macAddress
	{
		global taskUrl
		requestUrlWithPara := taskUrl . "?macAddress=" . macAddress
		responseInfo := _sendHttpRequest(requestUrlWithPara)
		logInfo(responseInfo)
		value := JSON.Load(responseInfo)
		return value
		;~ taskInfo := {}
		;~ Random, rand, 0, 1
		;~ if (rand)
		;~ {
			;~ taskInfo.account := _initAccount1()
		;~ }
		;~ else
		;~ {
			;~ taskInfo.account := _initAccount()
		;~ }
		
		;~ taskInfo.tasks := _initTasks()
		;~ return taskInfo
	}
}

reportTaskUrlFindInfo(accountId, videoId, result, info)
{
	global callbackUrl
	url := callbackUrl . "?type=2&accountId=" . accountId . "&videoId=" . videoId . "&result=" . finishStatus . "&info=" . info
	_sendHttpRequest(url)
}

reportTaskFinishInfo(accountId, videoId, result, info)
{
	global callbackUrl
	url := callbackUrl . "?type=1&accountId=" . accountId . "&videoId=" . videoId . "&result=" . result . "&info=" . info
	_sendHttpRequest(url)
}

;
reportAccountLoginInfo(accountId, result, info)
{
	global callbackUrl
	url := callbackUrl . "?type=0&accountId=" . accountId . "&result=" . result . "&info=" . info
	_sendHttpRequest(url)
}

returnAccountToRemoteServer(accountId)
{
	global callbackUrl
	url := callbackUrl . "?type=3&accountId=" . accountId
	_sendHttpRequest(url)
}

_sendHttpRequest(url)
{
	WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	;;1 min timeout
	WebRequest.SetTimeouts(60000, 60000, 60000, 60000)
	;MsgBox , % (url)
	WebRequest.Open("GET", url)
	WebRequest.Send(params)
	return WebRequest.ResponseText
}
