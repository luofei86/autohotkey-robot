;iqiyi account login logout
#Include IqiyiVcode.ahk
#Include IEDomUtils.ahk
#Include IqiyiAccountLoginPage.ahk


IqiyiAccoountHadAccountLogged(homepageWb)
{
	try{
		topUserNameEle := getUserLoginedDiv(homepageWb)
		if (topUserNameEle)
		{
			return (StrLen(topUserNameEle.innerHTML) > 0)
		}		
	}
	catch
	{
	}
	return false
}

IqiyiAccoountIsCurrentLoggedAccount(homepageWb, nickname)
{
	try{
		topUserNameEle := getUserLoginedDiv(homepageWb)
		pageNickname := topUserNameEle.innerHTML
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
		Loop, 10
		{
			userWidgetDiv := findIEElementInDom(homepageWb, "widget-userregistlogin")
			if (!userWidgetDiv)
			{
				return false
			}
			bbEles := userWidgetDiv.getElementsByTagName("b")
			if (bbEles)
			{
				bbEle := bbEles[0]				
				bbEle.focus()
				bbEle.click()
				global homepageUrl
				refershHomepageWb := IEDomGetByUrl(homepageUrl)
				divs := refershHomepageWb.document.getElementsByTagName("div")
				userBoxDiv := findIEElement(divs, "class", "nav-login-bd")
				logDebug("Goto find logout pop div.")
				if (userBoxDiv)
				{
					ahrefs := userBoxDiv.getElementsByTagName("a")
					if (ahrefs)
					{
						logoutBtn := findIEElement(ahrefs, "data-delegate", "j-logoutBtn")
						logDebug("Goto find logout btn")
						if (logoutBtn)
						{
							logoutBtn.click()
							Sleep 2000
							return true
						}
					}
				}
				else
				{
					;有的浏览器无法找到这个新弹出的div
					ahrefs := refershHomepageWb.document.getElementsByTagName("a")
					
					if (ahrefs)
					{
						logoutBtn := findIEElement(ahrefs, "data-delegate", "j-logoutBtn")
						logDebug("Goto find logout btn")
						if (logoutBtn)
						{
							logoutBtn.click()
							Sleep 2000
							return true
						}
					}
				}
			}
		}
	}
	return false
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
		searchAhref := findIEElement(ahrefs, "data-elem", "topLoginPanel")
		innerHTML := searchAhref.innerHTML
		return innerHTML = "登录"
	}catch
	{
		return False
	}
}
;accountName, accountPwd, account.nickname
;accountLoginInfo.result = 0 ok
;accountLoginInfo.info
;accountLoginInfo.byPop = 0:yes; 1:no; -1:dose not action login
;由于示正确填写nickname，所以对于用户登录后是否正确登录的判断取消，改为判断是否存在用户名
loginFromHomepage(homepageWb, account)
{
	accountLoginInfo := {"result": false, "info": "", "byPop": -1}
	global secureIndexUrl
	global useLoginIndexUrl
	if (homepageWb)
	{
		ahrefs := homepageWb.document.getElementById("widget-userregistlogin").getElementsByTagName("a")
		loginAhref := findIEElementByTwoAttr(ahrefs, "data-elem", "topLoginPanel", "j-delegate", "login")
		if (loginAhref)
		{
			loginAhref.focus()
			loginAhref.click()
			Sleep 1000
			popLoginDiv := homepageWb.document.getElementById("qipaLoginIfr")
			if(popLoginDiv)
			{
				return handleLoginByPoploginDiv(homepageWb, account)
			}
			else
			{
				secureIndexPageWb := IEDomGetByUrl(secureIndexUrl)
				if (secureIndexPageWb)
				{
					return handleLoginBySecureIndexPage(secureIndexPageWb, loginName, loginPwd)
				}			
				loginIndexPageWb := IEDomGetByUrl(useLoginIndexUrl)
				if(loginIndexPage)
				{
					return handleLoginByLoginIndexPage(loginIndexPageWb, loginName, loginPwd)
				}
				accountLoginInfo.info := "No login elements."
				return accountLoginInfo
			}
		}
		else
		{
			accountLoginInfo.info := "No login href"
		}
	}
	else
	{
		accountLoginInfo.info := "No page info."
	}
	return accountLoginInfo
}

handleLoginByPoploginDiv(homepageWb, account)
{
	accountLoginInfo := {"result": false, "info": "", "byPop": 0}
	Loop, 2
	{
		doLogin := loginFromHomePopPage(homepageWb, account.name, account.pwd)
		if(doLogin)
		{
			;~ logined := IqiyiAccoountIsCurrentLoggedAccount(homepageWb, account.nickname)
			logined := IqiyiAccoountHadAccountLogged(homepageWb)
			if(logined)
			{
				accountBanned := isAccountBanned()
				if(accountBanned)
				{
					accountLoginInfo.result := false
					accountLoginInfo.info := "Account banned."
				}
				else
				{
					accountLoginInfo.result :=true
				}
				return accountLoginInfo
			}else{
				loginFailedType := findLoginFailedType()
				if (loginFailedType = "ERROR_VCODE")
				{
					continue
				}
				else if(loginFailedType = "ERROR_PWD")
				{
					;登录失败汇报
					accountLoginInfo.info := "账号密码错误"
					return accountLoginInfo
				}else {					
					accountLoginInfo.info := loginFailedType
					return accountLoginInfo
				}
			}
		}
		else
		{
			accountLoginInfo.info := "无法完成登录信息输入."
		}
		return accountLoginInfo
	}
	return accountLoginInfo
}

isAccountBanned()
{
	global homepageUrl
	wb := IEDomGetByUrl(homepageUrl)
	innerHtml := wb.document.getElementsByTagName("body")[0].innerHTML
	return Instr(innerHtml, "账号因使用异常已被封停")
}

findLoginFailedType(){
	;get current page
	global homepageUrl
	homepageWb := IEDomGetByUrl(homepageUrl)
	if (homepageWb)
	{
		popLoginDiv := findIEElementInDom(homepageWb, "qipaLoginIfr")
		if (popLoginDiv)
		{
			;请输入图文验证码
			divEles := popLoginDiv.getElementsByTagName("div")
			errDivEle := findIEElement(divEles, "data-loginbox-elem", "errDom")
			if (errDivEle)
			{
				errorHtml := errDivEle.innerHTML
				if (errorHtml = "请输入图文验证码" or errorHtml = "请输入验证码")
				{
					return "ERROR_VCODE"
				}else if(errorHtml = "帐号或密码错误")
				{
					return "ERROR_PWD"
				}
				else
				{
					logError("Find err div ele innerhtml:" . errorHtml . " when login failed.")
					return "ERROR_UNKNOWN"
				}
			}
			return "ERROR_NOERRDIV"
		}
		return "ERROR_NOPOPLOGINDIV"
	}
	return "ERROR_NOHOMEPAGE"
}

handleLoginBySecureIndexPage(loginPageWb, loginName, loginPwd)
{
	accountLoginInfo := {"result": false, "info": "", "byPop": 1}
	global secureIndexUrl
	Loop, 2
	{
		doLogin := loginFromSecureIndexPage(loginPageWb, loginName, loginPwd)
		if(doLogin)
		{
			alsoExistLoginPageWb := IEDomGetByUrl(secureIndexUrl)
			if (!alsoExistLoginPageWb)
			{
				accountLoginInfo.result := true
				return accountLoginInfo
			}
			continue
		}
		else
		{
			accountLoginInfo.info := "无法完成登录信息输入."
			return accountLoginInfo
		}
	}
	accountLoginInfo.info := "登录失败"
	return accountLoginInfo
}

handleLoginByLoginIndexPage(loginPageWb, loginName, loginPwd)
{
	accountLoginInfo := {"result": false, "info": "", "byPop": 1}
	global useLoginIndexUrl
	Loop, 2
	{
		doLogin := loginFromSecureIndexPage(loginPageWb, loginName, loginPwd)
		if(doLogin)
		{
			alsoExistLoginPageWb := IEDomGetByUrl(useLoginIndexUrl)
			if (!alsoExistLoginPageWb)
			{
				accountLoginInfo.result := true
				return accountLoginInfo
			}
			continue
		}
		else
		{
			accountLoginInfo.info := "无法完成登录信息输入."
			return accountLoginInfo
		}
	}
	accountLoginInfo.info := "登录失败"
	return accountLoginInfo
}