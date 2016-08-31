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
						;~ <a href="http://www.iqiyi.com/u/" class="userName_link" target="_blank"><span class="name" rseat="1503081_2">爱吃甜品的南宫和宜</span></a>
						;~ <a class="qyvr-gray qyv-rank" href="http://www.iqiyi.com/club/" target="_blank" id="J_vip-kthy"></a></span><span class="tip">
						;~ <a href="http://serv.vip.iqiyi.com/order/renew-vip.action?fc=b1155904b6eaa861" class="vip_link" rseat="1503081_4" target="_blank">立即开通VIP 全站跳广告 大片随意看</a>
						;~ <a href="javascript:void(0)" class="vip_link ml20" target="_blank" rseat="1503081_13" data-delegate="j-logoutBtn">退出</a>
					;~ </span>
				;~ </div>
			;~ </div>
		;~ </div>
	;~ </div>
;~ </div>
;~ http://passport.iqiyi.com/user/login.php?url=http%3A%2F%2Fwww.iqiyi.com%2Fu%2F
IqiyiAccoountHadAccountLogged(homepageWb)
{
	try{
		return (StrLen(homepageWb.document.getElementById("top-username").innerHTML) > 0)
	}
	catch
	{
	}
	return false
}
IqiyiAccoountIsCurrentLoggedAccount(homepageWb, nickname)
{
	try{
		pageNickname := homepageWb.document.getElementById("top-username").innerHTML
		return pageNickname = nickname
	}
	catch
	{
	}
	return false
}
IqiyiLogoutFromHomepage(homepageWb)
{
	if (homepageWb)
	{
		userLoginedDiv := getUserLoginedDiv(homepageWb)
		
		if (userLoginedDiv)
		{
			;MsgBox "Find log out div"
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
		widghtUserRegistLoginDiv := homepageWb.document.getElementById("widget-userregistlogin")		
		ahrefs := widghtUserRegistLoginDiv.getElementsByTagName("a")
		if (ahrefs)
		{
			length := ahrefs.length
			Loop % length
			{
				ahref := ahrefs[A_Index -1]
				ahrefEleLoginboxElemValue := ahref.getAttribute("data-elem")
				if (ahrefEleLoginboxElemValue = "topLoginPanel")
				{
					innerHTML := ahref.innerHTML
					return loginText = "鐧诲綍"
				}
			}
		}
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
		;MsgBox "Pop login div"
		homepageWb.document.getElementById("widget-userregistlogin").getElementsByTagName("div")[3].getElementsByTagName("div")[0].getElementsByTagName("a")[0].click()
		Sleep 2000
		popLoginDiv := homepageWb.document.getElementById("qipaLoginIfr")
		Sleep 1000
		if(popLoginDiv)
		{
			return loginByPopDiv(homepageWb, loginName, loginPwd)
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
			else
			{
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
	accountLoginInfo.result := false
	accountLoginInfo.info := ""
	;######
	qipaLoginIfrDiv := homepageWb.document.getElementById("qipaLoginIfr")
	
	inputEles := qipaLoginIfrDiv.getElementsByTagName("input")
	inputElesLength := inputEles.length
	inputAccount := false
	inputPwd := false
	Loop % inputElesLength
	{
		inputEle := inputEles[A_Index - 1]
		inputEleType := inputEle.getAttribute("type")
		if (inputEleType = "password")
		{
			inputEleLoginboxElemValue := inputEle.getAttribute("data-loginbox-elem")
			if (inputEleLoginboxElemValue = "passwdInput")
			{
				inputPwd := SetInputEleValue(inputEle, loginPwd)
			}
		}
		else if(inputEleType = "text")
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
	
	Sleep 200
	vcodeExists := ExistsVcode(homepageWb)
	if (vcodeExists)
	{
		enterVcode(homepageWb)
	}
	;login
	ahrefs := qipaLoginIfrDiv.getElementsByTagName("a")
	if (ahrefs)
	{
		ahrefsLength := ahrefs.length
		Loop % ahrefsLength
		{
			ahref := ahrefs[A_Index -1]
			ahrefEleLoginboxElemValue := ahref.getAttribute("data-loginbox-elem")
			if (ahrefEleLoginboxElemValue = "loginBtn")
			{
				ahref.focus()
				ahref.click()
				Sleep 5000
			}
		}
	}
	else
	{
		accountLoginInfo.info := "The pop login div dose not find the login btn to click."
		logError("The pop login div dose not find the login btn to click.")
		return accountLoginInfo
	}
	userName := homepageWb.document.getElementById("top-username").innerHTML
	if (userName && StrLen(userName) > 0)
	{
		accountLoginInfo.result := true
		return accountLoginInfo
	}
	qipaLoginIfrDiv := homepageWb.document.getElementById("qipaLoginIfr")
	if (qipaLoginIfrDiv)
	{
		;娌℃湁鐧诲綍锛岄渶瑕佽緭鍏ヤ簩缁寸爜
		vcodeExists := ExistsVcode(homepageWb)
		if (vcodeExists)
		{
			enterVcode(homepageWb)
		}
	}
	Sleep 5000	
	userName := homepageWb.document.getElementById("top-username").innerHTML
	if (userName && StrLen(userName) > 0)
	{
		accountLoginInfo.result := true
		return accountLoginInfo
	}
	accountLoginInfo.info := "Login by pop login div failed."
	return accountLoginInfo
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
				return true
			}			
		}
	}
	Return False
}

