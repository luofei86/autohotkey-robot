;;;;server api handle
#Include MachineUtils.ahk
#Include LoggerUtils.ahk


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
	task.videoTimes := 60000
	tasks.Insert(task)
	
	task := {}
	task.id := 2
	task.searchKeyword := "冠军来了"
	task.searchUrl := "http://www.iqiyi.com/v_19rrlgel20.html"
	task.videoTimes := 60000
	tasks.Insert(task)	
	task := {}
	task.id := 3
	task.searchKeyword := "冠军来了"
	task.searchUrl := "http://www.iqiyi.com/v_19rrlxs0e8.html"
	task.videoTimes := 60000
	tasks.Insert(task)
	return tasks
}
;report task finish info to server
reportTaskFinishInfo(userId, taskId, finishStatus, finishInfo)
{
	
}

;
reportAccountLoginInfo(userId, loginStatus, loginInfo)
{
	
}
