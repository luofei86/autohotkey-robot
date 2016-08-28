;~ #Include tour/GetBroswerUrl.ahk

#Include IqiyiAccount.ahk
;wb := ComObjCreate("InternetExplorer.Application")
;wb.Visible := True
;wb.Navigate("http://iqiyi.com")

closePreIe()

;;;screen Resolution
WinGetPos,,, desk_width, desk_height, Program Manager
;MsgBox % "Desk width:" (desk_width) ", Desk height:" (desk_height)

homeUrl := "http://www.iqiyi.com/"
;homeUrl := "about:tabs"
;homePageWb := gotoHomepage("about:tabs")
homepageWb := gotoHomepage(homeUrl)
;homePageWb := IEGetByUrl(homeUrl)
if !homepageWb
{
	ExitApp
}
;Sleep 5000
;print pos
;MsgBox % homePageWb.document.innerHTML
;hidden menubar
;hiddenIeBar(homepageWb, "m")
;hidden favriote bar
;hiddenIeBar(homepageWb, "a")

MsgBox "Login out"
logoutFromHomepage(homepageWb)

MsgBox "Start login" 
loginFromHomepage(homepageWb, "13693243521", "1470-=p[]\l;'")

^q::
	closeWb(homepageWb, True)
ExitApp
;~ ^q::
	;~ homepageWb.quit

;~ ExitApp

searchKeyword := "夜店高薪招鉴黄师作神曲"
;searchUrl := "http://www.iqiyi.com/v_19rrlxsds8.html"
searchUrl := "http://www.iqiyi.com/w_19rt539vdt.html"
videoTimes := 5000

;Search
searchWb := gotoSearchPage(homepageWb, searchKeyword)
if !searchWb
{
	homepageWb.quit
	ExitApp
}

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
^j::
{
;~ ;Sleep % videoTimes
	closeWb(videoWb)
	closeWb(searchWb)
	closeWb(homepageWb, True)
}
ExitApp

hiddenIeBar(wb, keystore)
{
	pWin := wb.Document.ParentWindow
	;~ for k, v in pWin
	;~ {
		;~ MsgBox % "Key:" (key) ", Value:" (value)
	;~ }
	;~ MsgBox, % IsObject(homePageWb.Document.ParentWindow) ;
	;MsgBox % "Before pWin.screenLeft" (pWin.screenLeft) ", pWin.screenTop:" (pWin.screenTop)
	preTop := pWin.screenTop

	;MsgBox % "Mouse screen left" (xpos) ", Mouse screen  Top:" (ypos)
	global desk_width
	moveToPos(desk_width/2, pWin.screenTop)
	MouseClick Right
	Sleep 1000
	Send {%keystore%}
	Sleep 1000
	;MsgBox % "After pWin.screenLeft" (pWin.screenLeft) ", pWin.screenTop:" (pWin.screenTop)
	afterClickTop := pWin.screenTop
	MsgBox % "Before move top:" (preTop) ", after move Top:" (afterClickTop)
	if (afterClickTop > preTop)
	{
		MsgBox "Show menu bar hidding it"
		MouseClick Right
		Sleep 1000
		Send {%keystore%}
		Sleep 1000
	}
	else
	{
			MsgBox "Hidden menu bar"
	}
		
}

moveToPos(left, top)
{
	;MsgBox % "Move to X:" (left) ",Y:" (top)
	MouseGetPos, xpos, ypos
	;MsgBox % "Mouse X:" (xpos) ",Y:" (ypos)
	mouseMoveX := left - xpos
	mouseMoveY := top - ypos +5
	;MsgBox % "Moves X:" (mouseMoveX) ",Y:" (mouseMoveY)
	MouseMove, mouseMoveX, mouseMoveY, 50, R
}


closeWb(wb, last = false){
	if wb
	{
		try
		{
			wb.quit
			if !last
			{
				Sleep 2000
			}
		}
		catch{}
	}
}
gotoHomepage(loadUrl)
{
	homePageWb := ComObjCreate("InternetExplorer.Application") ;create a IE instance
	homePageWb.Visible := True
	if(StrLen(loadUrl) > 0)
	{
		homePageWb.Navigate(loadUrl)		
	}else{
		homePageWb.Navigate("about:Tabs")
	}
	;IELoad(homePageWb)
	;OutputDebug, "Load main page"

	WinMaximize, % "ahk_id " homePageWb.HWND
	Sleep 200
	Wait(homePageWb)
	return homePageWb
}

gotoSearchPage(homePageWb, searchKeyword)
{
	;Search

	doSearch(homePageWb, searchKeyword)

	;Wait(homePageWb)
	;MsgBox "Wait loading search result"
	Sleep 2000
	;wb.quit

	searchWb := IEGet(searchKeyword)
	if !searchWb
	{
		MsgBox "No get Search page"
		return
	}
	Wait(searchWb)
	return searchWb
}

gotoResultUrlPage(searchUrl)
{
	videoWb := IEGetByUrl(searchUrl)
	if videoWb
	{
		Wait(videoWb)
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
;~ bottom
;~ :
;~ 686
;~ height
;~ :
;~ 631
;~ left
;~ :
;~ 271.5
;~ right
;~ :
;~ 1331.5
;~ top
;~ :
;~ 55
		Sleep % sleepTimeMis
		MsgBox "Played"
	}
	;~ MsgBox % "Body:" (wb.document.getElementsByTagName("body")[0].innerHTML)
}

closePreIe()
{
	; Close all windows (open/minimized, browsers) but not pwr off
	WinGet, id, list,,, Program Manager
	Loop, %id%
	{
		this_id := id%A_Index% 
		;WinActivate, ahk_id %this_id%
		WinGetClass, this_class, ahk_id %this_id%
		;WinGetTitle, this_title, ahk_id %this_id%
		;MsgBox % "Class:" (this_class) ", Title:" (this_title)
		if (this_class = "IEFrame")
		{
			WinClose, ahk_id %this_id%;
		}
		;If(this_class != "Shell_traywnd") && (this_class != "Button")  ; If class is not Shell_traywnd and not Button
		;	WinClose, ahk_id %this_id% ;This is what it should be ;MsgBox, This ahk_id %this_id% ; Easier to test ;)
	}
}
;close all ie page exclude iqiyi homepage
closeExcludeIqiyiHomePagePage()
{
}

;getSearchResult(wb, searchUrl, ByRef resultWinTitles)
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
			return True
		}
	}
	return False
}

doSearch(wb, searchKeyword)
{
	searchForm := wb.document.getElementsByTagName("form")[0]
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

IEGetByUrl(searchUrl)
{
    For wb in ComObjCreate( "Shell.Application" ).Windows
	{
		if InStr(wb.FullName, "iexplore.exe" )
		{
			try
			{
				wbUrl := wb.document.URL				
				if InStr(wbUrl, searchUrl)
				{
					MsgBox % "Find wb by url:" (searchUrl)
					return wb
				}
			}
			catch e
			{}
		}
	}
}
IEGet(Name="") ;Retrieve pointer to existing IE window/tab
{
    IfEqual, Name,, WinGetTitle, Name, ahk_class IEFrame
	Name := ( Name="New Tab - Windows Internet Explorer" ) ? "about:Tabs"
        : RegExReplace( Name, " - (Windows|Microsoft) Internet Explorer" )
    For wb in ComObjCreate( "Shell.Application" ).Windows
	{
		if (InStr(wb.FullName, "iexplore.exe" ))
		{
			Wait(wb)
			if (wb.LocationName = Name || InStr(wb.LocationName, Name))
			{
				Return wb
			}
		}
		
	}
}

IELoad(wb)    ;You need to send the IE handle to the function unless you define it as global.
{
    If !wb    ;If wb is not a valid pointer then quit
        Return False
 ;   Loop    ;Otherwise sleep for .1 seconds untill the page starts loading
   ;     Sleep,100
   ; Until (wb.busy)
    Loop    ;Once it starts loading Wait until completes
        Sleep,100
    Until (!wb.busy)
    Loop    ;optional check to wait for the page to completely load
        Sleep,100
    Until (wb.Document.Readystate = "Complete")
	Return True
}

Wait(wb)
{
	while(wb.ReadyState !=4) or (wb.busy)
		Sleep 100
}