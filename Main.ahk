;~ #Include tour/GetBroswerUrl.ahk

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
		taskLength := remoteTaskInfo.tasks.length
		if (taskLength = 0)
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
		;;clear the env
		closePreIe()
		;setting
		settingIe()
		Sleep 1000
		;;check the env
		
		;;;是否可以上网
		
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
		logInfo("Logout the iqiyi account.")
		logged := IqiyiAccoountHadAccountLogged(homepageWb)
		accountLogged := false
		
		if (logged)
		{
			accountLogged := IqiyiAccoountIsCurrentLoggedAccount(homepageWwb, account.nickname)
			if (!accountLogged)
			{
				IqiyiLogoutFromHomepage(homepageWb)
				Sleep 2000
			}
		}
		if (!accountLogged)
		{
			accountLoginInfo := loginFromHomepage(homepageWb, accountName, accountPwd)
			if (!accountLoginInfo.result)
			{
				reportAccountLoginInfo(accountId, accountLoginInfo.result, accountLoginInfo.info)
				SleepBeforeNextLoop()
				continue
			}
		}		
		logInfo("Logined the iqiyi account.")
		;play video
		Loop % taskLength
		{
			taskInfo := remoteTaskInfo.tasks[A_Index]
			;fuzzyUserRandomAccessWebsite(homepageWb)
			searchKeyword := taskInfo.searchKeyword
			;searchUrl := "http://www.iqiyi.com/v_19rrlxsds8.html"
			searchUrl := taskInfo.searchUrl
			videoTimes := taskInfo.videoTimes
			searchWb := gotoSearchPage(homepageWb, searchKeyword)
			if !searchWb
			{
				continue
			}
			findResult := clickToSearchUrlPage(searchWb, searchUrl)
			
			;MsgBox "FIND SEARCH RESULT AND CLICK IT."
			findResult := clickToSearchUrlPage(searchWb, searchUrl)
			;wb.quit
			if findResult
			{
				videoWb := gotoResultUrlPage(searchUrl)
				if videoWb
				{
					startAndWaitVideoPlayFinished(videoWb, videoTimes)
				}
			}
			else
			{
				;goto direct
			}
		}
		;restart the route
		
	}catch{
		
	}
}



^q::
{
	logInfo("The user press ctrl+q, the app exit")
	closePreIe()
	ExitApp
}

SleepBeforeNextLoop()
{
	try{
		logInfo("Sleep 30000 before next loop")
		Sleep 30000
	}
	catch
	{
	}
}
