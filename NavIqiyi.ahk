;wb := ComObjCreate("InternetExplorer.Application")
;wb.Visible := True
;wb.Navigate("http://iqiyi.com")

;wb := IEget("about:Tabs")
wb := ComObjCreate("InternetExplorer.Application") ;create a IE instance
wb.Visible := True
wb.Navigate("http://www.iqiyi.com/")
IELoad(wb)

;Search
gotoSearch(wb)

;Wait(wb)
;MsgBox "Wait loading search result"
Sleep 1000


wb := IEGet("夜店高薪招鉴黄师作神曲")
if !wb
{
	return
}
;MsgBox "Find posibile links"
posibileLinks := getSearchResult(wb)

;MsgBox % "END Find posibile links " (posibileLinks)
for posibileLink in posibileLinks
{
	MsgBox % "Url:" (posibileLink.getAttribute("href"))
}

getSearchResult(wb)
{
	Links := Object()
	;MsgBox % "Links:" (wb.document.getElementsByTagName("body")[0].innerHTML)
	
	length := wb.document.links.length
	Loop, %length%
	{
		MsgBox "Links:" %A_Index%
		anchorLink := wb.document.links[A_index]
		MsgBox % "Links:" (anchorLink.getAttribute("href"))
		linkClass := anchorLink.getAttribute("class")
		;MsgBox % "CLASS:" (linkClass)
		if linkClass = "figure figure-180101"
		{
			Links.Insert(anchorLink)
		}
	}
	return Links
}


gotoSearch(wb)
{
	searchForm := wb.document.getElementsByTagName("form")[0]
	searchInput := searchForm.getElementsByTagName("div")[0].getElementsByTagName("span")[0].getElementsByTagName("input")[0]
	Sleep 1000
	searchInput.focus()
	searchInput.value := "夜店高薪招鉴黄师作神曲"
	Sleep 1000
	;searchForm.submit()
	Send {Enter}
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



IEGet(Name="")        ;Retrieve pointer to existing IE window/tab
{
    IfEqual, Name,, WinGetTitle, Name, ahk_class IEFrame
        Name := ( Name="New Tab - Windows Internet Explorer" ) ? "about:Tabs"
        : RegExReplace( Name, " - (Windows|Microsoft) Internet Explorer" )
    For wb in ComObjCreate( "Shell.Application" ).Windows{
		;MsgBox	% "Browser name:" (wb.LocationName)
        If ( wb.LocationName = Name || InStr(wb.LocationName, Name)) && InStr( wb.FullName, "iexplore.exe" )
			Return wb
	}
} ;written by Jethrow

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