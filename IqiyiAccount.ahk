;iqiyi account login logout

#Include IqiyiVcode.ahk
#Include IEDomUtils.ahk
#Include IqiyiAccountLoginPage.ahk
secureIndexUrl := "http://passport.iqiyi.com/pages/secure/index.action"
useLoginIndexUrl := "http://passport.iqiyi.com/user/login.php"

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
					Loop, 10
					{
						if(isLogout(homepageWb))
						{
							return true
						}
						Sleep 1000
					}
				}
				catch{}
			}
			Sleep 2000
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
					MsgBox % (innerHTML)
					return innerHTML = "登录"
				}
			}
		}
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
		;MsgBox "Pop login div"
		homepageWb.document.getElementById("widget-userregistlogin").getElementsByTagName("div")[3].getElementsByTagName("div")[0].getElementsByTagName("a")[0].click()
		Sleep 2000
		popLoginDiv := homepageWb.document.getElementById("qipaLoginIfr")
		Sleep 1000
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
			loginIndexPageWb := IEDomGetUrl(useLoginIndexUrl)
			if(loginIndexPage)
			{
				return handleLoginByLoginIndexPage(loginIndexPageWb, loginName, loginPwd, nickname)
			}
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