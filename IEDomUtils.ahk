#Include MouseMoveUtils.ahk
#Include LoggerUtils.ahk

EleExistsAndDisplay(ele)
{
	try
	{
		if (ele)
		{
			rect := ele.getBoundingClientRect()
			if (rect)
			{
				MsgBox, % "Top:" (rect.top) ", left:" (rect.left) ", bottom:" (rect.bottom)
				eleHidden := ((rect.bottom -rect.top) <> 0)
				return eleHidden
			}
		}
	}
	catch
	{
	}
	return false
}
SetInputEleValue(inputEle, value)
{
	;MsgBox "Find input pwd"
	try{
		inputEle.focus()
		inputEle.click()
		Sleep 500
		inputEle.value := value
		Sleep 2000
		return true
	}
	catch
	{
		return false
	}
}

closeIEDomExcludiveHomepage(homepageWb)
{
	if (!homepageWb)
	{
		return
	}
	homepageWbHwnd := homepageWb.HWND
	For wb in ComObjCreate( "Shell.Application" ).Windows
	{
		if InStr(wb.FullName, "iexplore.exe" )
		{
			try
			{
				curHwnd := wb.HWND
				if(curHwnd != homepageWbHwnd)
				{
					closeWb(wb)
				}
			}
			catch e
			{}
		}
	}	
}

closeIEDomExcludiveHomepageAndReFresh(homepageWb)
{
	closeIEDomExcludiveHomepage(homepageWb)
	Sleep 500
	IEPageActive(homepageWb)
	Send {F5}
	Sleep 5000
}

IEDomGetByUrl(url)
{
    For wb in ComObjCreate( "Shell.Application" ).Windows
	{
		if InStr(wb.FullName, "iexplore.exe" )
		{
			try
			{
				wbUrl := wb.document.URL
				IEDomWait(wb)
				if InStr(wbUrl, url)
				{
					;MsgBox % "Find wb by url:" (url)
					return wb
				}
			}
			catch e
			{}
		}
	}
}

IEDomGet(name = "") ;Retrieve pointer to existing IE window/tab
{
    IfEqual, name,, WinGetTitle, name, ahk_class IEFrame
	name := ( name = "New Tab - Windows Internet Explorer" ) ? "about:Tabs"
        : RegExReplace( name, " - (Windows|Microsoft) Internet Explorer" )
    For wb in ComObjCreate( "Shell.Application" ).Windows
	{
		if (InStr(wb.FullName, "iexplore.exe" ))
		{
			url := getIEDomLocationUrl(wb)
			locationName := getIEDomLocationName(wb)
			logInfo("Find dom by name:" . name . ", Current loop wb url:" . url . ", location name:" . locationName)
			if(StrLen(locationName) = 0)
			{
				continue
			}
			IEDomWait(wb)
			if (locationName = name || InStr(locationName, name))
			{				
				return wb
			}
		}		
	}
}

getIEDomLocationName(wb)
{
	try
	{
		return wb.LocationName
	}
	catch
	{
	}	
}

getIEDomLocationUrl(wb)
{
	try
	{
		return wb.document.URL
	}
	catch
	{
	}	
}

IEDomLoad(wb)    ;You need to send the IE handle to the function unless you define it as global.
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

findIEElementByTwoAttr(eles, attrName0, attrValue0,  attrName1, attrValue1)
{
	length := eles.length
	Loop % length
	{
		ele := eles[A_Index-1]
		if(eleAttrEquals(ele, attrName0, attrValue0) and eleAttrEquals(ele, attrName1, attrValue1))
		{
			return ele
		}
	}
}

findIEElementInDom(wb, eleId)
{
	if wb
	{
		return wb.document.getElementById(eleId)
	}
}

findIEElement(eles, attrName, attrValue)
{
	length := eles.length
	Loop % length
	{
		ele := eles[A_Index-1]
		if(eleAttrEquals(ele, attrName, attrValue))
		{
			return ele
		}
	}
}

eleAttrEquals(ele, attrName, attrValue)
{
	return ele.getAttribute(attrName) = attrValue
}

IEDomWait(wb)
{
	loops := 0
	while(((wb.ReadyState !=4) or (wb.busy)) and loops < 100)
	{
		Sleep 100
		loops := loops + 1
	}
}

;display menu bar
settingIe()
{
	baiduHomepageWb := gotoUrl("https://www.baidu.com")
	if (!baiduHomepageWb)
	{
		return false
	}
	;ÊÕ²Ø¼Ð
	hiddenIEBar(baiduHomepageWb, "A")
	Sleep 1000
	;²Ëµ¥À¸
	hiddenIEBar(baiduHomepageWb, "E")
	Sleep 1000
	;ÃüÁîÀ¸
	hiddenIEBar(baiduHomepageWb, "O")
	Sleep 1000
	baiduHomepageWb.quit
}


gotoUrl(url)
{
	homePageWb := ComObjCreate("InternetExplorer.Application") ;create a IE instance
	homePageWb.Visible := true
	homePageWb.Navigate(url)
	Sleep 200
	IEDomWait(homePageWb)	
	WinMaximize, % "ahk_id " homePageWb.HWND
	Sleep 1000
	return homePageWb
}

IEPageActive(wb)
{
	if wb
	{
		WinShow, % "ahk_id " wb.HWND
		WinActivate, % "ahk_id " wb.HWND
		wb.Visible := true
	}
}

hiddenIEBar(wb, keystore)
{
	pWin := wb.Document.ParentWindow
	preTop := pWin.screenTop
	moveToPos(A_ScreenWidth/2, pWin.screenTop)
	MouseClick Right
	Sleep 1000
	Send {%keystore%}
	Sleep 1000
	afterClickTop := pWin.screenTop
	;MsgBox % "Before move top:" (preTop) ", after move Top:" (afterClickTop)
	if (afterClickTop > preTop)
	{
		;MsgBox "Show menu bar hidding it"
		MouseClick Right
		Sleep 1000
		Send {%keystore%}
		Sleep 1000
	}
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
