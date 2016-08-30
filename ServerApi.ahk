;;;;server api handle
#Include MachineUtils.ahk

;getRemoteInfo()

;根据机器码来获取需要播放的视频信息,由服务器确保当前账号只分发给一台机器处理
getRemoteTaskInfo()
{
	macAddress := GetMacAddress()
	if macAddress
	{
		;MsgBox % macAddress
	}
	;ver := ""
}
;report task finish info to server
reportTaskFinishInfo(userId, taskId, finishStatus, finishInfo)
{
	
}

;
reportAccountLoginInfo(userId, loginStatus, loginInfo)
{
	
}
