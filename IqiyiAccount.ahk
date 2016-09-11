;iqiyi account login logout
#Include IqiyiVcode.ahk
#Include IEDomUtils.ahk
#Include IqiyiAccountLoginPage.ahk

secureIndexUrl := "http://passport.iqiyi.com/pages/secure/index.action"
useLoginIndexUrl := "http://passport.iqiyi.com/user/login.php"

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
				divs := homepageWb.document.getElementsByTagName("div")				
				userBoxDiv := findIEElement(divs, "class", "nav-login-bd")
				if (userBoxDiv)
				{
					;userBoxDiv.focus()
					ahrefs := userBoxDiv.getElementsByTagName("a")
					if (ahrefs)
					{
						logoutBtn := findIEElement(ahrefs, "data-delegate", "j-logoutBtn")						
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

loginFromHomepage(homepageWb, loginName, loginPwd, nickname)
{
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
				return handleLoginByPoploginDiv(homepageWb, loginName, loginPwd, nickname)
			}
			else
			{
				secureIndexPageWb := IEDomGetByUrl(secureIndexUrl)
				if (secureIndexPageWb)
				{
					return handleLoginBySecureIndexPage(secureIndexPageWb, loginName, loginPwd, nickname)
				}			
				loginIndexPageWb := IEDomGetByUrl(useLoginIndexUrl)
				if(loginIndexPage)
				{
					return handleLoginByLoginIndexPage(loginIndexPageWb, loginName, loginPwd, nickname)
				}
				return false
			}
		}
		else
		{
			return false
		}
		
	}
	return false
}

handleLoginByPoploginDiv(homepageWb, loginName, loginPwd, nickname)
{
	Loop, 2
	{
		doLogin := loginFromHomePopPage(homepageWb, loginName, loginPwd)
		if(doLogin)
		{
			logined := IqiyiAccoountIsCurrentLoggedAccount(homepageWb, nickname)
			if(logined)
			{
				return true
			}
			continue
		}
		return false
	}
	return false
}

handleLoginBySecureIndexPage(loginPageWb, loginName, loginPwd, nickname)
{
	global secureIndexUrl
	Loop, 2
	{
		doLogin := loginFromSecureIndexPage(loginPageWb, loginName, loginPwd)
		if(doLogin)
		{
			alsoExistLoginPageWb := IEDomGetByUrl(secureIndexUrl)
			if (!alsoExistLoginPageWb)
			{
				return true
			}
			continue
		}
		return false
	}
	return false
}

handleLoginByLoginIndexPage(loginPageWb, loginName, loginPwd, nickname)
{
	global useLoginIndexUrl
	Loop, 2
	{
		doLogin := loginFromSecureIndexPage(loginPageWb, loginName, loginPwd)
		if(doLogin)
		{
			alsoExistLoginPageWb := IEDomGetByUrl(useLoginIndexUrl)
			if (!alsoExistLoginPageWb)
			{
				return true
			}
			continue
		}
		return false
	}
	return false
}