;iqiyi account login logout

#Include IqiyiVcode.ahk
#Include IEDomUtils.ahk

;pop logout
;~ <div class="nav-login-info nav-login-info-new" id="nav-login-info">
	;~ <div class="nav-login-inner">
		;~ <span class="nav-login_arrow"><i class="tip_outer"></i> <i class="tip_inner"></i></span>
		;~ <div class="nav-login-bd">
			;~ <div class="nav-login-top clearfix">
				;~ <div class="img"><a href="http://www.iqiyi.com/u/" target="_blank" rseat="1503081_1" class="homeLink">
					;~ <img src="http://www.qiyipic.com/common/fix/headicons/male-70.png" width="50" height="50" rseat="1503081_1" alt=""></a>
				;~ </div>
				;~ <div class="title">
					;~ <span class="userName clearfix">
						;~ <a href="http://www.iqiyi.com/u/" class="userName_link" target="_blank"><span class="name" rseat="1503081_2">������Ʒ���Ϲ�����</span></a>
						;~ <a class="qyvr-gray qyv-rank" href="http://www.iqiyi.com/club/" target="_blank" id="J_vip-kthy"></a></span><span class="tip">
						;~ <a href="http://serv.vip.iqiyi.com/order/renew-vip.action?fc=b1155904b6eaa861" class="vip_link" rseat="1503081_4" target="_blank">������ͨVIP ȫվ����� ��Ƭ���⿴</a>
						;~ <a href="javascript:void(0)" class="vip_link ml20" target="_blank" rseat="1503081_13" data-delegate="j-logoutBtn">�˳�</a>
					;~ </span>
				;~ </div>
			;~ </div>
		;~ </div>
	;~ </div>
;~ </div>
;~ http://passport.iqiyi.com/user/login.php?url=http%3A%2F%2Fwww.iqiyi.com%2Fu%2F
logoutFromHomepage(homepageWb)
{
	if (homepageWb)
	{
		userLoginedDiv := getUserLoginedDiv(homepageWb)
		
		if (userLoginedDiv)
		{
			MsgBox "Find log out div"
			userLoginedDiv.click()
			popDiv := homepageWb.document.getElementById("nav-login-info")
			if (popDiv)
			{
				try
				{
					popDiv.getElementsByTagName("div")[0].getElementsByTagName("div")[0].getElementsByTagName("div")[0].getElementsByTagName("div")[1].getElementsByTagName("a")[3].click()
					Loop
						if(isLogout(homepageWb))
						{
							break
						}
						Sleep 1000
				}
				catch{}
			}
			Sleep 2000
		}
		
	}
}

getUserLoginedDiv(homepageWb)
{
	return homepageWb.document.getElementById("top-username")
}

isLogout(homepageWb)
{
	try{
		loginText := homepageWb.document.getElementById("widget-userregistlogin").getElementsByTagName("div")[3].getElementsByTagName("div")[0].getElementsByTagName("a")[0].innerHTML
		MsgBox % loginText
		return loginText = "��¼"
	}catch
	{
		return False
	}
}
;login http://passport.iqiyi.com/pages/secure/index.action
loginFromSecureIndexPage(secureIndexPage, loginName, loginPwd)
{	
	;MsgBox % (secureIndexPage.document.body.innerHTML)
	inputElements := secureIndexPage.document.getElementsByTagName("input")
	length := inputElements.length
	inputAccount := False
	inputPwd := False		
	Loop % length
	{
		inputEle := inputElements[A_Index-1]
		inputEleType := inputEle.getAttribute("type")
		if (inputEleType = "password")
		{
			inputEleLoginboxElemValue := inputEle.getAttribute("data-loginbox-elem")
			if (inputEleLoginboxElemValue = "passwdInput")
			{
				inputPwd := SetInputEleValue(inputEle, loginPwd)
			}
		}else if(inputEleType = "text")
		{
			inputEleLoginboxElemValue := inputEle.getAttribute("data-loginbox-elem")				
			if (inputEleLoginboxElemValue = "emailInput")
			{
				inputAccount := SetInputEleValue(inputEle, loginName)
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
	return False
}

loginFromHomepage(homepageWb, loginName, loginPwd)
{
	if (homepageWb)
	{
		MsgBox "Pop login div"
		homepageWb.document.getElementById("widget-userregistlogin").getElementsByTagName("div")[3].getElementsByTagName("div")[0].getElementsByTagName("a")[0].click()
		Sleep 2000
		popLoginDiv := homepageWb.document.getElementById("qipaLoginIfr")
		Sleep 1000
		if(popLoginDiv)
		{
			loginByPopDiv(homepageWb, loginName, loginPwd)
		}else{
			;open login page
			;url like http://passport.iqiyi.com/user/login.php?url=http%3A%2F%2Fwww.iqiyi.com%2Fu%2F or 
			;url like http://passport.iqiyi.com/pages/secure/index.action
			secureIndexPage := IEDomGetByUrl("http://passport.iqiyi.com/pages/secure/index.action")
			if (secureIndexPage)
			{
				logined := loginFromSecureIndexPage(secureIndexPage, loginName, loginPwd)
				if(logined)
				{
					
				}
			}
			
			
		}
		Sleep 1000
	}
	return False
}

loginByLoginPage()
{
	
}

loginByPopDiv(homepageWb, loginName, loginPwd)
{
		
	;######
	homepageWb.document.getElementById("qipaLoginIfr").getElementsByTagName("div")[0].getElementsByTagName("div")[0].getElementsByTagName("div")[1].getElementsByTagName("table")[0].getElementsByTagName("div")[0].getElementsByTagName("input")[0].focus()
	Sleep 200
	homepageWb.document.getElementById("qipaLoginIfr").getElementsByTagName("div")[0].getElementsByTagName("div")[0].getElementsByTagName("div")[1].getElementsByTagName("table")[0].getElementsByTagName("div")[0].getElementsByTagName("input")[0].click()
	Sleep 200
	homepageWb.document.getElementById("qipaLoginIfr").getElementsByTagName("div")[0].getElementsByTagName("div")[0].getElementsByTagName("div")[1].getElementsByTagName("table")[0].getElementsByTagName("div")[0].getElementsByTagName("input")[0].value := loginName

	Sleep 2000
	SetKeyDelay, 500
	Send {Tab}

	homepageWb.document.getElementById("qipaLoginIfr").getElementsByTagName("div")[0].getElementsByTagName("div")[0].getElementsByTagName("div")[1].getElementsByTagName("table")[0].getElementsByTagName("div")[1].getElementsByTagName("input")[1].focus()
	homepageWb.document.getElementById("qipaLoginIfr").getElementsByTagName("div")[0].getElementsByTagName("div")[0].getElementsByTagName("div")[1].getElementsByTagName("table")[0].getElementsByTagName("div")[1].getElementsByTagName("input")[1].value := loginPwd
	Sleep 200
	vcodeExists := ExistsVcode(homepageWb)
	if (vcodeExists)
	{
		enterVcode(homepageWb)		
		Return
	}
	else
	{	
		;MsgBox "No pic code"
		Send {Enter}
	}
	;;;;login
	Sleep 2000
	;find logined
	if (getUserLoginedDiv(homepageWb))
		return True
	if (!vcodeExists)
	{
		if (ExistsVcode(homepageWb))
		{
			enterVcode(homepageWb)
			return getUserLoginedDiv(homepageWb)
		}
	}
	return False
}


ExistsVcode(homepageWb)
{
	table := homepageWb.document.getElementById("qipaLoginIfr").getElementsByTagName("div")[0].getElementsByTagName("div")[0].getElementsByTagName("div")[1].getElementsByTagName("table")[0]
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

