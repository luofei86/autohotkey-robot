﻿;~ #Include tour/GetBroswerUrl.ahk

#Include Iqiyi.ahk
#Include IqiyiAccount.ahk
#Include ServerApi.ahk
#Include LoggerUtils.ahk
#Include IEDomUtils.ahk
;wb := ComObjCreate("InternetExplorer.Application")
;wb.Visible := True
;wb.Navigate("http://iqiyi.com")


;;;screen Resolution
WinGetPos,,, desk_width, desk_height, Program Manager
;MsgBox % "Desk width:" (desk_width) ", Desk height:" (desk_height)



Loop
{
	try{
		remoteTaskInfo := ServerApiGetRemoteTaskInfo()
		taskLength := remoteTaskInfo.tasks.MaxIndex()
		if (!taskLength || taskLength = 0)
		{
			;current no task
			;Sleep 30 seconds
			SleepBeforeNextLoop()
			continue
		}
		account := remoteTaskInfo.account
		accountId := account.id
		accountName := account.name
		accountPwd := account.pwd
		if(!account || !accountId || !accountName || !accountPwd)
		{
			SleepBeforeNextLoop()
			continue
		}
		;;clear the env
		closePreIe()
		;setting
		;settingIe()
		;Sleep 1000
		;;check the env
			
		;;get task
		
		;login first
		homepageWb := IqiyiGotoHomepage()
		if !homepageWb
		{
			logError("Load the iqiyi homepage failed.")
			SleepBeforeNextLoop()
			continue
		}
		Sleep 1000
		logInfo("Get the iqiyi homepage account login status.")
		logged := IqiyiAccoountHadAccountLogged(homepageWb)
		accountLogged := false		
		if (logged)
		{
			accountLogged := IqiyiAccoountIsCurrentLoggedAccount(homepageWb, account.nickname)
			if (!accountLogged)
			{
				logInfo("Logout from the homepage. Pre logined account dose not equal current account." . account.accountName)
				IqiyiLogoutFromHomepage(homepageWb)
				Sleep 2000
			}
		}
		if (!accountLogged)
		{
			logInfo("Login from the homepage.")
			accountLogined := loginFromHomepage(homepageWb, accountName, accountPwd, account.nickname)
			if (!accountLogined)
			{
				logError("Failed to login from the homepage.")
				reportAccountLoginInfo(accountId, accountLoginInfo.result, accountLoginInfo.info)
				SleepBeforeNextLoop()
				continue
			}
			else
			{
				closeIEDomExcludiveHomepageAndReFresh(homepageWb)
			}
		}
		logInfo("Logined the iqiyi account:" . accountName)
		;play video
		tasks := remoteTaskInfo.tasks
		;MsgBox , % (tasks[0])
		;MsgBox , % (tasks[1])
		Loop % taskLength
		{
			
			taskInfo := tasks[A_Index]
			;fuzzyUserRandomAccessWebsite(homepageWb)
			searchKeyword := taskInfo.searchKeyword
			;searchUrl := "http://www.iqiyi.com/v_19rrlxsds8.html"
			url := taskInfo.url
			duration := taskInfo.duration * 1000
			IEPageActive(homepageWb)
			searchWb := gotoSearchPage(homepageWb, searchKeyword)
			logInfo("Loop the video:" . url)
			if !searchWb
			{
				logError("Loop the video:" . url . ", but dose not found by the searchKeyword:" . searchKeyword)
				closeIEDomExcludiveHomepage(homepageWb)
				continue
			}
			IEPageActive(searchWb)			
			logInfo("Click to the search url page:" . url)
			findResult := clickToSearchUrlPage(searchWb, url)
			
			;MsgBox "FIND SEARCH RESULT AND CLICK IT."
			;findResult := clickToSearchUrlPage(searchWb, url)
			;wb.quit
			if findResult
			{
				videoWb := gotoResultUrlPage(url)
				if videoWb
				{
					startAndWaitVideoPlayFinished(videoWb, duration)
					logInfo("Finished play the video at video page:" . url)					
					;IEPageActive(videoWb)
					Sleep 500
					logInfo("Close video page:" . url)
					closeWb(videoWb)
					Sleep 2000
				}
				closeWb(searchWb)
			}
			else
			{
				logInfo("Can not find the search url:" . url . " by search keyword:" . searchKeyword . " in the first search result page.")
				;goto direct
			}
			closeIEDomExcludiveHomepage(homepageWb)			
		}
		logInfo("Finish play the account's video:" . accountName . ". Restart the route.")
		;restart the route
		closePreIe()
		restartRoute()
	}
	catch
	{
		
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
		Sleep 30000
	}
	catch
	{
	}
}
