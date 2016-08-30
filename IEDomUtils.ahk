
;test
;url like http://passport.iqiyi.com/user/login.php?url=http%3A%2F%2Fwww.iqiyi.com%2Fu%2F or 
;url like http://passport.iqiyi.com/pages/secure/index.action

^u::
{
	loginWb := IEDomGetByUrl("http://passport.iqiyi.com/user/login.php")
	;"13693243521", "1470-=p[]\l;'")
	loginPwd := "1470-=p[]\l;'"
	loginName := "13693243521"
	if loginWb
	{
		MsgBox % (loginWb.document.body.innerHTML)
	}
	secureIndexPage := IEDomGetByUrl("http://passport.iqiyi.com/pages/secure/index.action")
	if secureIndexPage
	{
		;MsgBox % (secureIndexPage.document.body.innerHTML)
		inputElements := secureIndexPage.document.getElementsByTagName("input")
		length := inputElements.length
		inputAccount := False
		inputPwd := False		
		Loop % length
		{
			inputEle := inputElements[A_Index-1]
			;MsgBox % inputEle.classname
			;MsgBox % (inputEle.getAttribute("type"))
			inputEleType := inputEle.getAttribute("type")
			if (inputEleType = "password")
			{
				inputEleLoginboxElemValue := inputEle.getAttribute("data-loginbox-elem")
				if (inputEleLoginboxElemValue = "passwdInput")
				{
					;MsgBox "Find input pwd"
					inputEle.focus()
					inputEle.click()
					Sleep 500
					inputEle.value := loginPwd
					Sleep 2000
					inputPwd := True
				}
			}else if(inputEleType = "text")
			{
				inputEleLoginboxElemValue := inputEle.getAttribute("data-loginbox-elem")				
				if (inputEleLoginboxElemValue = "emailInput")
				{
					;MsgBox "Find input pwd"
					inputEle.focus()
					inputEle.click()
					Sleep 500
					inputEle.value := loginName
					Sleep 2000
					inputAccount := True
				}
			}
			if(inputAccount && inputPwd)
			{
				break
			}
		}
		if(inputAccount && inputPwd)
		{
			;login press enter
			ahrefs := secureIndexPage.document.getElementsByTagName("a")
			if (ahrefs)
			{
				length := ahrefs.length
				Loop % length
				{
					ahref := ahrefs[A_Index -1]
					ahrefEleLoginboxElemValue := ahref.getAttribute("data-loginbox-elem")
					if (ahrefEleLoginboxElemValue = "loginBtn")
					{
						ahref.focus()
						ahref.click()
						Sleep 3000
						IEDomWait(secureIndexPage)
						userNmae := document.getElementById("top-username").innerHTML
						if (userName && StrLen(userName) > 0)
						{
							return True
						}						
						break
					}
				}
			}
		}
		
	}

	ExitApp
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
		return True
	}
	catch
	{return False}
}

IEDomGetByUrl(searchUrl)
{
    For wb in ComObjCreate( "Shell.Application" ).Windows
	{
		if InStr(wb.FullName, "iexplore.exe" )
		{
			try
			{
				wbUrl := wb.document.URL
				IEDomWait(wb)
				if InStr(wbUrl, searchUrl)
				{
					;MsgBox % "Find wb by url:" (searchUrl)
					return wb
				}
			}
			catch e
			{}
		}
	}
}
IEDomGet(Name="") ;Retrieve pointer to existing IE window/tab
{
    IfEqual, Name,, WinGetTitle, Name, ahk_class IEFrame
	Name := ( Name="New Tab - Windows Internet Explorer" ) ? "about:Tabs"
        : RegExReplace( Name, " - (Windows|Microsoft) Internet Explorer" )
    For wb in ComObjCreate( "Shell.Application" ).Windows
	{
		if (InStr(wb.FullName, "iexplore.exe" ))
		{
			IEDomWait(wb)
			if (wb.LocationName = Name || InStr(wb.LocationName, Name))
			{
				Return wb
			}
		}
		
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

IEDomWait(wb)
{
	while(wb.ReadyState !=4) or (wb.busy)
		Sleep 100
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
