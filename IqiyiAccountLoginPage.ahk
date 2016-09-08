;;IqiyiAccountLoginPage.ahk

#Include IqiyiVcode.ahk
#Include IEDomUtils.ahk
#Include LoggerUtils.ahk

loginFromHomePopPage(loginPage, loginName, loginPwd)
{
	loginStatus := loginFromLoginIndexPage(loginPage, loginName, loginPwd)
	return loginStatus
}

;login http://passport.iqiyi.com/user/login.php
loginFromLoginIndexPage(loginPage, loginName, loginPwd)
{
	inputedAccount := initAccountInput(loginPage, loginName)
	if (!inputedAccount)
	{
		logError("Failed set account in account input ele in login page.")
		return false
	}
	inputedPasswd := initPwdInput(loginPage, loginPwd)
	if (!inputedPasswd)
	{
		logError("Failed set pwd in account input ele in login page.")
		return false
	}
	inputedVcode := initVcodeInput(loginPage)
	if(!inputedVcode)
	{
		logError("Failed set vcode in account input ele in login page.")
		return false
	}
	clickedLoginBtn := clickLoginBtn(loginPage)
	if(!clickedLoginBtn)
	{
		logError("Failed click login btn in account input ele in login page.")
		return false
	}
	;wait login
	Sleep 5000
	return true
}

;login http://passport.iqiyi.com/pages/secure/index.action
loginFromSecureIndexPage(secureIndexPage, loginName, loginPwd)
{
	loginStatus := loginFromLoginIndexPage(secureIndexPage, loginName, loginPwd)
	return loginStatus
}




initAccountInput(loginPage, loginName)
{
	inputElements := loginPage.document.getElementsByTagName("input")
	accountInputEle := findIEElementByTwoAttr(inputElements, "type", "text", "data-loginbox-elem", "emailInput")
	if (!accountInputEle)
	{
		logError("Does not find the account input ele in login page.")
		return false
	}
	inputedAccount := SetInputEleValue(accountInputEle, loginName)
	return inputedAccount
}

initPwdInput(loginPage, loginPwd)
{
	inputElements := loginPage.document.getElementsByTagName("input")
	passwdInputEle := findIEElementByTwoAttr(inputElements, "type", "password", "data-loginbox-elem", "passwdInput")
	if (!passwdInputEle)
	{
		logError("Does not find the pwd input ele in login page.")
		return false
	}
	inputedPasswd := SetInputEleValue(passwdInputEle, loginPwd)
	return inputedPasswd
}

initVcodeInput(loginPage)
{
	spanElements := loginPage.document.getElementsByTagName("span")
	vcodeEle := findIEElement(spanElements, "data-loginbox-elem", "piccode")
	if (EleExistsAndDisplay(vcodeEle))
	{
		inputElements := loginPage.document.getElementsByTagName("input")
		vcodeInputEle := findIEElementByTwoAttr(inputElements, "type", "text", "data-loginbox-elem", "piccodeInput")
		if (!EleExistsAndDisplay(vcodeInputEle))
		{
			return false
		}
		;enterVcode(pageWb, imgEle, inputVcodeEle)
		enteredVcode := enterVcode(loginPage, vcodeEle, vcodeInputEle)
		if (!enteredVcode)
		{
			logError("Dose not enter vode.")
			return false
		}
		return true
	}
	return true
}

clickLoginBtn(loginPage)
{
	ahrefs := loginPage.document.getElementsByTagName("a")
	loginBtn := findIEElement(ahrefs, "data-loginbox-elem", "loginBtn")
	if(loginBtn)
	{
		loginBtn.click()
		Sleep 500
		return true
	}
	return false
}
