homeUrl := "http://www.iqiyi.com/"
#Include IEDomUtils.ahk
#Include LoggerUtils.ahk
;homeUrl := "about:tabs"
;homePageWb := gotoHomepage("about:tabs")


IqiyiGotoHomepage()
{
	global homeUrl
	homepageWb := gotoUrl(homeUrl)
	;~ homePageWb := ComObjCreate("InternetExplorer.Application") ;create a IE instance
	;~ homePageWb.Visible := True
	;~ homePageWb.Navigate(loadUrl)
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

	doSearch(homePageWb, searchKeyword)
	Sleep 2000
	searchWb := IEDomGet(searchKeyword)
	if !searchWb
	{
		;MsgBox "No get Search page"
		logError("No get Search page by searchword:" . searchKeyword)
		return
	}
	IEDomWait(searchWb)
	return searchWb
}

doSearch(homePageWb, searchKeyword)
{
	searchForm := homePageWb.document.getElementsByTagName("form")[0]
	searchInput := searchForm.getElementsByTagName("div")[0].getElementsByTagName("span")[0].getElementsByTagName("input")[0]
	Sleep 1000
	searchInput.focus()
	searchInput.value := searchKeyword
	Sleep 1000
	;searchForm.submit()
	Send {Enter}
	;MsgBox "Enter to search"
	Sleep 1000
}


clickToSearchUrlPage(searchWb, searchUrl)
{
	Links :=searchWb.document.links
	length := searchWb.document.links.length
	Loop % length
	{
		anchorLink := Links[A_index-1]
		href := anchorLink.getAttribute("href")
		if InStr(href, searchUrl)
		{
			anchorLink.click()
			return true
		}
	}
	return false
}


gotoResultUrlPage(searchUrl)
{
	videoWb := IEDomGetByUrl(searchUrl)
	if videoWb
	{
		IEDomWait(videoWb)
		return videoWb
	}
}

startAndWaitVideoPlayFinished(videoWb, sleepTimeMis)
{
	pWin := videoWb.document.parentWindow
	flashPlayer := videoWb.document.getElementById("flash")
	if flashPlayer
	{
		;~ MouseGetPos, xpos, ypos
		;~ ;
		;~ global desk_height
		;~ ;MsgBox % "Xpos:" (xpos) "Ypos:" (ypos)
		;~ pos := findPos(flashPlayer)
		;~ ;MsgBox % "bottom:" (pos.bottom) ", left:" (pos.left) ", top:" (pos.top)
		;~ mouseGoToX := pos.left + pWin.screenLeft  + 30
		;~ mouseGoToY := pos.bottom + 20
		;~ mouseMoveX := mouseGoToX - xpos
		;~ mouseMoveY := (desk_height - ypos) - mouseGoToY 
		;~ ;MsgBox % "Mouse move X:" (mouseMoveX) ", Mouse move Y:" (mouseMoveY)
		;~ ;MsgBox, 0, code img, %	"Left:	"		pos.left + pWin.screenLeft ; left side of element rectagle + left side of screen
		;~ ;							.	"`nTop:	"		pos.top + pWin.screenTop
		;~ ;							.	"`nRight:	"	pos.right + pWin.screenLeft
		;~ ;							.	"`nBottom:	"	pos.bottom + pWin.screenTop
		;~ MouseMove, mouseMoveX, mouseMoveY, 50, R
		;~ MouseClick, left
		;~ Sleep 1000
		;MouseGetPos, xpos, ypos
		;MsgBox % "Xpos:" (xpos) "Ypos:" (ypos)
		Sleep % sleepTimeMis
		logInfo("Played")
	}
}