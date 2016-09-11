;~ #Include tour/GetBroswerUrl.ahk

#Include Iqiyi.ahk
#Include IqiyiAccount.ahk
#Include ServerApi.ahk
#Include LoggerUtils.ahk
#Include IEDomUtils.ahk

WinGetPos,,, desk_width, desk_height, Program Manager

Loop
{
	try{
		remoteTaskInfo := ServerApiGetRemoteTaskInfo()		
		account := remoteTaskInfo.account
		accountId := account.id
		accountName := account.name
		accountPwd := account.pwd
		if(!account || !accountId || !accountName || !accountPwd)
		{
			logError("No account from server.")
			SleepBeforeNextLoop()
			continue
		}
		taskLength := remoteTaskInfo.tasks.MaxIndex()
		if (!taskLength || taskLength = 0)
		{
			logError("No task from server.")
			returnAccountToRemoteServer(accountId)
			SleepBeforeNextLoop()
			continue
		}
		closePreIe()		
		homepageWb := IqiyiGotoHomepage()
		if !homepageWb
		{
			logError("Load the iqiyi homepage failed.")
			returnAccountToRemoteServer(accountId)
			SleepBeforeNextLoop()
			continue
		}
		Sleep 500
		logInfo("Get the iqiyi homepage account login status.")
		logged := IqiyiAccoountHadAccountLogged(homepageWb)
		accountLogged := false		
		if (logged)
		{
			accountLogged := IqiyiAccoountIsCurrentLoggedAccount(homepageWb, account.nickname)
			if (!accountLogged)
			{
				logInfo("Logout from the homepage. Pre logined account dose not equal current account." . accountName)
				IqiyiLogoutFromHomepage(homepageWb)
				IEPageActive(homepageWb)
				Send {F5}
				IEDomWait(homepageWb)
				Sleep 2000
			}
		}
		if (!accountLogged)
		{
			logInfo("Login from the homepage. accountId:" . accountId)
			accountLogined := loginFromHomepage(homepageWb, accountName, accountPwd, account.nickname)
			if (!accountLogined)
			{
				logError("Failed to login from the homepage.")
				reportAccountLoginInfo(accountId, accountLoginInfo.result, accountLoginInfo.info)
				returnAccountToRemoteServer(accountId)
				SleepBeforeNextLoop()
				continue
			}
			else
			{
				closeIEDomExcludiveHomepageAndReFresh(homepageWb)
			}
		}
		logInfo("Logined the iqiyi account:" . accountName)		
		tasks := remoteTaskInfo.tasks
		loopPlayVideoTasks(homepageWb, tasks, taskLength, accountId)
		
		logInfo("Finish play the account's video:" . accountName . ". Restart the route.")
		;restart the route
		closePreIe()
		restartRoute()
	}
	catch e
	{
		logException(e)
		;return account
		if (account)
		{
			returnAccountToRemoteServer(account.id)
		}
	}
}

loopPlayVideoTasks(homepageWb, tasks, taskLength, accountId)
{
	Loop % taskLength
	{
		taskInfo := tasks[A_Index]
		;fuzzyUserRandomAccessWebsite(homepageWb)
		searchKeyword := taskInfo.searchKeyword			
		url := taskInfo.url
		duration := taskInfo.duration * 1000
		try
		{
			IEPageActive(homepageWb)
			logInfo("Start to search " . searchKeyword .  " at home page.")
			searchWb := gotoSearchPage(homepageWb, searchKeyword)			
			if !searchWb
			{
				logError("Loop the video:" . url . ", but dose not found by the searchKeyword:" . searchKeyword)
				closeIEDomExcludiveHomepage(homepageWb)
				continue
			}
			IEPageActive(searchWb)			
			logInfo("Search url " . url . " on the search result page:")
			findResult := clickSearchUrlLinkAtSearchResultPage(searchWb, url)
			if findResult
			{
				videoWb := gotoResultUrlPage(url)
				if videoWb
				{
					played := startAndWaitVideoPlayFinished(videoWb, duration)
					;(accountId, videoId, result, info)
					if (played)
					{
						reportTaskFinishInfo(accountId, taskInfo.id, 0, "Finished")
						logInfo("Finished play the video at video page:" . url)
					}
					else
					{
						reportTaskFinishInfo(accountId, taskInfo.id, -1, "Find the video page:" . url . ", But dose not finished play.")
						logWarn("Can not finished play the video at video page:" . url)
					}
					logInfo("Close video page:" . url)
					closeWb(videoWb)
					Sleep 2000					
				}
				else
				{
					reportTaskFinishInfo(accountId, taskInfo.id, -2, "Can not find video page by url:" . url)
				}
				closeWb(searchWb)
			}
			else
			{
				logWarn("Can not find the search url:" . url . " by search keyword:" . searchKeyword . " in the first search result page.")
				;(accountId, videoId, result, info)
				reportTaskUrlFindInfo(accountId, taskInfo.id, -1, "Missed")
				;goto direct
			}
			closeIEDomExcludiveHomepage(homepageWb)
		}
		catch e
		{
			logException(e)
			Sleep 500
		}
	}
}


^q::
{
	logInfo("The user press ctrl+q, the app exit")
	closePreIe()
	ExitApp
}

restartRoute()
{
	SleepBeforeNextLoop()
}

SleepBeforeNextLoop()
{
	closePreIe()
	try{
		logInfo("Sleep 30000 before next loop")
		Sleep 3000
	}
	catch
	{
	}
}
