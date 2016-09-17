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
		;~ global taskUrl
		;~ requestUrlWithPara := taskUrl . "?macAddress=" . macAddress
		;~ ;MsgBox , % (requestUrlWithPara)
		;~ responseInfo := _sendHttpRequest(requestUrlWithPara)
		;~ ;MsgBox , % (responseInfo)
		;~ logDebug(responseInfo)
		;~ MsgBox, % (responseInfo)
		;~ value := JSON.Load(responseInfo)
		;~ return value
		taskInfo := {}
		Random, rand, 0, 1
		if (rand)
		{
			taskInfo.account := _initAccount1()
		}
		else
		{
			taskInfo.account := _initAccount()
		}
		
		taskInfo.tasks := _initTasks()
		return taskInfo
	}
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


_initAccount1()
{
	account := {}
	account.id := 2
	account.nickname := "SandyWangTing"
	account.name := "13810954201"
	account.pwd := "19871007wt"
	return account
}

_initTasks()
{
	tasks := Object()
	task := {}
	task.id := 1
	task.searchKeyword := "G20"
	task.url := "http://www.iqiyi.com/lib/m_210812214.html"
	task.duration := 20
	tasks.Insert(task)
	
	;~ task := {}
	;~ task.id := 2
	;~ task.searchKeyword := "G20"
	;~ task.url := "http://www.iqiyi.com/v_19rrm5n2to.html"
	;~ task.duration := 20
	;~ tasks.Insert(task)	
	;~ task := {}
	;~ task.id := 3
	;~ task.searchKeyword := "G20"
	;~ task.url := "http://www.iqiyi.com/w_19rsva5uxd.html"
	;~ task.duration := 20
	;~ tasks.Insert(task)	
	;~ task := {}
	;~ task.id := 4
	;~ task.searchKeyword := "G20"
	;~ task.url := "http://www.iqiyi.com/w_19rsoreazx.html"
	;~ task.duration := 20
	;~ tasks.Insert(task)	
	;~ task := {}
	;~ task.id := 5
	;~ task.searchKeyword := "G20"
	;~ task.url := "http://www.iqiyi.com/v_19rrm497sg.html"
	;~ task.duration := 20
	;~ tasks.Insert(task)	
	;~ task := {}
	;~ task.id := 6
	;~ task.searchKeyword := "G20"
	;~ task.url := "http://www.iqiyi.com/w_19rst5ju0d.html#vfrm=2-3-0-1"
	;~ task.duration := 20
	;~ tasks.Insert(task)
	return tasks
}
;report task finish info to server

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
