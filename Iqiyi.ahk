﻿#Include IEDomUtils.ahk
#Include LoggerUtils.ahk

IqiyiGotoHomepage()
{
	global homepageUrl
	homepageWb := gotoUrl(homepageUrl)
	if homepageWb
	{
		WinMaximize, % "ahk_id " homepageWb.HWND
		Sleep 500
		logInfo("Loaded iqiyi homepage")
	}
	else
	{
		logWarn("Load iqiyi homepage failed, can not find the page." . homepageUrl)
	}
	return homepageWb
}

IqiyiGotoPage(url)
{
	pageWb := gotoUrl(url)
	if pageWb
	{
		WinMaximize, % "ahk_id " pageWb.HWND
		Sleep 500
	}
	else
	{
		logWarn("Failed to Load iqiyi page:" . url)
	}
	return pageWb
}

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
	if (!searchWb)
	{
		searchWb := deepthFindSearchResultPage(searchKeyword)
		if(searchWb)
		{
			logInfo("Get the search:" . searchKeyword . " result page wb.")
			return searchWb
		}
		logError("No get Search page by searchword:" . searchKeyword)
		return
	}	
	logInfo("Get the search:" . searchKeyword . " result page wb.")
	return searchWb
}

deepthFindSearchResultPage(searchKeyword)
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
	{
	}
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
	{
	}
}

doSearch(homePageWb, searchKeyword)
{
	IEPageActive(homePageWb)
	searchForm := homePageWb.document.getElementsByTagName("form")[0]
	searchInput := searchForm.getElementsByTagName("div")[0].getElementsByTagName("span")[0].getElementsByTagName("input")[0]
	Sleep 1000
	searchInput.focus()
	Sleep 500
	searchInput.click()
	searchInput.value := searchKeyword
	Sleep 1000
	searchBtn := searchForm.getElementsByTagName("div")[0].getElementsByTagName("span")[1].getElementsByTagName("input")[0]
	if (searchBtn)
	{
		searchBtn.click()
	}
}

clickSearchUrlLinkAtSearchResultPage(searchWb, url)
{
	findUrl := formatUrl(url)
	Links := searchWb.document.links
	length := searchWb.document.links.length
	Loop % length
	{
		anchorLink := Links[A_index-1]
		href := anchorLink.getAttribute("href")
		if InStr(href, findUrl)
		{
			anchorLink.click()
			logInfo("Click to access the search url:" . findUrl)
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
	if (flashPlayer)
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
				MouseClick, left
			}
		}
		global adTimeMis
		;80000 ad time
		moreSleepTimeMis := sleepTimeMis + adTimeMis
		Sleep % moreSleepTimeMis
		return true
	}
	return false
}