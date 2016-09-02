﻿;;;;server api handle
#Include MachineUtils.ahk
#Include LoggerUtils.ahk

taskUrl := "http://zhaopai.tv/crontab/aqiyi.playvideo.php"
callbackUrl := "http://zhaopai.tv/crontab/aqiyi.playvideo.callback.php"

ServerApiGetRemoteTaskInfo()

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
		;MsgBox % macAddress
		;accountNickname
		;accountName;
		;accountId;
		;accountPwd;
		;tasks
		;~ global taskUrl
		;~ requestUrlWithPara := taskUrl . "?macAddress=" . macAddress
		;~ ;MsgBox , % (requestUrlWithPara)
		;~ responseInfo := _sendHttpRequest(requestUrlWithPara)
		;~ MsgBox , % (responseInfo)
		;~ logDebug(responseInfo)
		
		
		taskInfo := {}
		taskInfo.account := _initAccount()
		taskInfo.tasks := _initTasks()
		return taskInfo
	}
	;ver := ""
}
_initAccount()
{
	account := {}
	account.id := 1
	account.nickname := "爱吃甜品的南宫和宜"
	account.name := "13693243521"
	account.pwd := "1470-=p[]\l;'"
	return account
}
_initTasks()
{
	tasks := Object()
	task := {}
	task.id := 1
	task.searchKeyword := "冠军来了"
	task.searchUrl := "http://www.iqiyi.com/v_19rrlll2k4.html"
	task.videoTimes := 20000
	tasks.Insert(task)
	
	task := {}
	task.id := 2
	task.searchKeyword := "冠军来了"
	task.searchUrl := "http://www.iqiyi.com/v_19rrlgel20.html"
	task.videoTimes := 20000
	tasks.Insert(task)	
	task := {}
	task.id := 3
	task.searchKeyword := "冠军来了"
	task.searchUrl := "http://www.iqiyi.com/v_19rrlxs0e8.html"
	task.videoTimes := 20000
	tasks.Insert(task)	
	task := {}
	task.id := 4
	task.searchKeyword := "冠军来了"
	task.searchUrl := "http://www.iqiyi.com/v_19rrleefds.html"
	task.videoTimes := 20000
	tasks.Insert(task)	
	task := {}
	task.id := 5
	task.searchKeyword := "冠军来了"
	task.searchUrl := "http://www.iqiyi.com/v_19rrlsezm8.html"
	task.videoTimes := 20000
	tasks.Insert(task)	
	task := {}
	task.id := 6
	task.searchKeyword := "冠军来了"
	task.searchUrl := "http://www.iqiyi.com/v_19rrm66xrc.html"
	task.videoTimes := 20000
	tasks.Insert(task)
	return tasks
}
;report task finish info to server

reportTaskUUrlFindInfo(accountId, videoId, result, info)
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
;returnAccountToRemoteServer(1)
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
