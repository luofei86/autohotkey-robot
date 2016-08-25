;~ #Include tour/GetBroswerUrl.ahk

;wb := ComObjCreate("InternetExplorer.Application")
;wb.Visible := True
;wb.Navigate("http://iqiyi.com")

;wb := IEget("about:Tabs")


closePreIe()

WinGetPos,,, desk_width, desk_height, Program Manager



homeUrl := "http://www.iqiyi.com/"
homeUrl := "about:tabs"
;homePageWb := gotoHomepage("about:tabs")
homePageWb := gotoHomepage(homeUrl)

if !homePageWb
{
	ExitApp
}

;print pos
pWin := videoWb.document.parentWindow
MsgBox % "pWin.screenLeft" () "" ()

Sleep 6000
searchKeyword := "夜店高薪招鉴黄师作神曲"
;searchUrl := "http://www.iqiyi.com/v_19rrlxsds8.html"
searchUrl := "http://www.iqiyi.com/w_19rt539vdt.html"
videoTimes := 1000

;Search
searchWb := gotoSearchPage(homePageWb, searchKeyword)
if !searchWb
{
	homePageWb.quit
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
;Sleep % videoTimes
	closeWb(videoWb)
	closeWb(searchWb)
	closeWb(homePageWb, True)
}
ExitApp

closeWb(wb, last = false){
	if wb
	{
		wb.quit
		if !last
		{
			Sleep 2000
		}
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
	IELoad(homePageWb)
	;OutputDebug, "Load main page"

	WinMaximize, % "ahk_id " homePageWb.HWND
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
		MouseGetPos, xpos, ypos
		;
		global desk_height
		;MsgBox % "Xpos:" (xpos) "Ypos:" (ypos)
		pos := findPos(flashPlayer)
		;MsgBox % "bottom:" (pos.bottom) ", left:" (pos.left) ", top:" (pos.top)
		mouseGoToX := pos.left + pWin.screenLeft  + 30
		mouseGoToY := pos.bottom + 20
		mouseMoveX := mouseGoToX - xpos
		mouseMoveY := (desk_height - ypos) - mouseGoToY 
		;MsgBox % "Mouse move X:" (mouseMoveX) ", Mouse move Y:" (mouseMoveY)
		;MsgBox, 0, code img, %	"Left:	"		pos.left + pWin.screenLeft ; left side of element rectagle + left side of screen
		;							.	"`nTop:	"		pos.top + pWin.screenTop
		;							.	"`nRight:	"	pos.right + pWin.screenLeft
		;							.	"`nBottom:	"	pos.bottom + pWin.screenTop
		MouseMove, mouseMoveX, mouseMoveY, 50, R
		MouseClick, left
		Sleep 1000
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
login(wb)
{
	pWin := wb.document.parentWindow
	;MsgBox % wb.document.getElementById("widget-userregistlogin").innerHTML
	;MsgBox "Hello"
	Sleep 1000
	wb.document.getElementById("widget-userregistlogin").getElementsByTagName("div")[3].getElementsByTagName("div")[0].getElementsByTagName("a")[0].click()

	Sleep 2000

	;######
	wb.document.getElementById("qipaLoginIfr").getElementsByTagName("div")[0].getElementsByTagName("div")[0].getElementsByTagName("div")[1].getElementsByTagName("table")[0].getElementsByTagName("div")[0].getElementsByTagName("input")[0].focus()
	wb.document.getElementById("qipaLoginIfr").getElementsByTagName("div")[0].getElementsByTagName("div")[0].getElementsByTagName("div")[1].getElementsByTagName("table")[0].getElementsByTagName("div")[0].getElementsByTagName("input")[0].value := "13693243521"

	Sleep 2000
	SetKeyDelay, 500
	Send {Tab}

	wb.document.getElementById("qipaLoginIfr").getElementsByTagName("div")[0].getElementsByTagName("div")[0].getElementsByTagName("div")[1].getElementsByTagName("table")[0].getElementsByTagName("div")[1].getElementsByTagName("input")[1].focus()
	wb.document.getElementById("qipaLoginIfr").getElementsByTagName("div")[0].getElementsByTagName("div")[0].getElementsByTagName("div")[1].getElementsByTagName("table")[0].getElementsByTagName("div")[1].getElementsByTagName("input")[1].value := "1470-=p[]\l;'"

	Sleep 2000
	if (ExistsVcode(wb))
	{
		;MsgBox "Move to img"
		moveToImg(wb, pWin)
		Sleep 2000			
		MouseClick, right
		Sleep 1000
		Send {s}
		Sleep 500
		Send {Enter}
		Sleep 500
		Send {Tab}
		Sleep 500
		Send {Enter}
		Return
	}
	else
	{	
		;MsgBox "No pic code"
		Send {Enter}
	}
	;;;;login
	Sleep 1000
	;MsgBox "Login"
	if (ExistsVcode(wb))
	{
		;MsgBox "Move to img"
		moveToImg(wb, pWin)
		Sleep 2000			
		MouseClick, right
		Sleep 1000
		Send {s}
		Sleep 500
		Send {Enter}
		Sleep 500
		Send {Tab}
		Sleep 500
		Send {Enter}
		Return
	}
	else
	{
		MsgBox "No pic code"
	}
}
;;;是否存在验证码

moveToImg(wb, pWin)
{
	table := wb.document.getElementById("qipaLoginIfr").getElementsByTagName("div")[0].getElementsByTagName("div")[0].getElementsByTagName("div")[1].getElementsByTagName("table")[0]
	tbody := table.getElementsByTagName("tbody")[0]
	trs :=  tbody.getElementsByTagName("tr")
	if (trs && trs.length >=3)
	{
		dataElem := trs[2].getAttribute("data-loginbox-elem")		
		if (dataElem = "piccodeTr")
		{
			tds := trs[2].getElementsByTagName("td")
			divs := tds[0].getElementsByTagName("div")
			spans := divs[0].getElementsByTagName("span")
			images := spans[1].getElementsByTagName("img")
			if (images && images.length >0)
			{
				MouseGetPos, xpos, ypos 
				;MsgBox % "Cur mouse xpos:" (xpos) " ypos:" (ypos)
				;MsgBox % "pWin xpos:" (pWin.screenLeft) " ypos:" (pWin.screenTop)
				img := images[0]
				pos := findPos(img)
				;MsgBox % "Cur img Top:" (pos.top) " Left:" (pos.left) "Right:" (pos.right)
				mouseGoToX := pos.left + pWin.screenLeft  + 30
				mouseGoToY := pos.top + pWin.screenTop + 30
				mouseMoveX := mouseGoToX - xpos
				mouseMoveY := mouseGoToY - ypos
				;MsgBox % "Mouse move X:" (mouseMoveX) ", Mouse move Y:" (mouseMoveY)
				;MsgBox, 0, code img, %	"Left:	"		pos.left + pWin.screenLeft ; left side of element rectagle + left side of screen
				;							.	"`nTop:	"		pos.top + pWin.screenTop
				;							.	"`nRight:	"	pos.right + pWin.screenLeft
				;							.	"`nBottom:	"	pos.bottom + pWin.screenTop
				MouseMove, mouseMoveX, mouseMoveY, 50, R
				return True
			}			
		}
	}
	return False
}

findPos(el) {
    if (el.getBoundingClientRect)
	{
        return el.getBoundingClientRect()
	}
    else {
        x = 0, y = 0
        loop
        {
            x += el.offsetLeft - el.scrollLeft
            y += el.offsetTop - el.scrollTop
        } until (el = el.offsetParent)
        return "left:" x ", " "top:" y
    }      
}

ExistsVcode(wb)
{
	table := wb.document.getElementById("qipaLoginIfr").getElementsByTagName("div")[0].getElementsByTagName("div")[0].getElementsByTagName("div")[1].getElementsByTagName("table")[0]
	tbody := table.getElementsByTagName("tbody")[0]
	trs :=  tbody.getElementsByTagName("tr")	
	if (trs && trs.length >=3)
	{
		dataElem := trs[2].getAttribute("data-loginbox-elem")		
		if (dataElem = "piccodeTr"){
			tds := trs[2].getElementsByTagName("td")
			divs := tds[0].getElementsByTagName("div")
			spans := divs[0].getElementsByTagName("span")
			images := spans[1].getElementsByTagName("img")
			if (images && images.length >0)
			{
				Return True
			}			
		}
	}
	Return False
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
		if InStr(wb.FullName, "iexplore.exe" ) && (wb.LocationName = Name || InStr(wb.LocationName, Name))
		{
				Return wb
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
    Loop    ;Once it starts loading wait until completes
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