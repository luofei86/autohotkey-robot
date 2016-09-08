homeUrl := "http://www.iqiyi.com/"
#Include IEDomUtils.ahk
#Include LoggerUtils.ahk
;homeUrl := "about:tabs"
;homePageWb := gotoHomepage("about:tabs")


IqiyiGotoHomepage()
{
	global homeUrl
	homepageWb := gotoUrl(homeUrl)
	if homepageWb
	{
		WinMaximize, % "ahk_id " homepageWb.HWND
		Sleep 500
		logInfo("Loaded iqiyi homepage")
	}
	else
	{
		logWarn("Load iqiyi homepage failed")
	}
	return homepageWb
}

;random access the homepage to Confuse the server
fuzzyUserRandomAccessWebsite(homepageWb)
{
	
}



gotoSearchPage(homePageWb, searchKeyword)
{
	;Search
	logInfo("Start search " . searchKeyword)
	doSearch(homePageWb, searchKeyword)
	Sleep 5000
	searchWb := IEDomGet(searchKeyword)
	if !searchWb
	{
		;MsgBox "No get Search page"
		;list all ie page to decide
		searchWb := deepthFindSearchResultPage(searchKeyword)
		if(searchWb)
		{
			return searchWb
		}
		logError("No get Search page by searchword:" . searchKeyword)
		return
	}	
	logInfo("Get the search:" . searchKeyword . " result page wb.")
	Sleep 500
	return searchWb
}

deepthFindSearchResultPage(searchKeyword) ;Retrieve pointer to existing IE window/tab
{
    searchWb := IEDomGetByUrl("http://so.iqiyi.com/so/")
	searchInputEle := findIEElementInDom(searchWb, "data-widget-searchword")
	try
	{
		if (searchInputEle.value = searchKeyword)
		{
			return searchWb
		}
	}
	catch
	{}
	eles := searchWb.document.getElementsByTagName("div")
	searchContentEle := findIEElement(eles, "class", "search_content")
	try
	{
		if (Instr(searchContentEle.innerHTML, searchKeyword))
		{
			return searchWb
		}
	}
	catch
	{}
}

doSearch(homePageWb, searchKeyword)
{
	searchForm := homePageWb.document.getElementsByTagName("form")[0]
	searchInput := searchForm.getElementsByTagName("div")[0].getElementsByTagName("span")[0].getElementsByTagName("input")[0]
	Sleep 1000
	searchInput.focus()
	Sleep 500
	searchInput.click()
	searchInput.value := searchKeyword
	Sleep 1000
	Send {Enter}
}


clickToSearchUrlPage(searchWb, url)
{
	Links :=searchWb.document.links
	length := searchWb.document.links.length
	Loop % length
	{
		anchorLink := Links[A_index-1]
		href := anchorLink.getAttribute("href")
		if InStr(href, url)
		{
			anchorLink.click()
			logInfo("Click to access the search url:" . url)
			return true
		}
	}
	return false
}


gotoResultUrlPage(url)
{
	videoWb := IEDomGetByUrl(url)
	if videoWb
	{
		IEDomWait(videoWb)
		return videoWb
	}
}

startAndWaitVideoPlayFinished(videoWb, sleepTimeMis)
{
	flashPlayer := videoWb.document.getElementById("flash")
	if flashPlayer
	{
		paramEles := flashPlayer.getElementsByTagName("param")
		flashVarsEle := findIEElement(paramEles, "name", "flashVars")
		if (flashVarsEle)
		{
			varValue := flashVarsEle.getAttribute("value")
			if !InStr(varValue, "autoplay=true")
			{
				;move to click play
				pWin := videoWb.document.parentWindow
				moveToPosWithBottom(flashPlayer, pWin)
			}
				
		}
		;moreSleepTimeMis := sleepTimeMis + 60000
		moreSleepTimeMis := sleepTimeMis + 6000
		Sleep % moreSleepTimeMis
	}
}