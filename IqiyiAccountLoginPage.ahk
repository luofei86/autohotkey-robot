;;IqiyiAccountLoginPage.ahk

#Include IqiyiVcode.ahk
#Include IEDomUtils.ahk
#Include LoggerUtils.ahk


;login http://passport.iqiyi.com/user/login.php
loginFromLoginIndexPage(loginPage, loginName, loginPwd)
{
	inputElements := loginPage.document.getElementsByTagName("input")
	passwdInputEle := findIEElementByTwoAttr(inputElements, "type", "password", "data-loginbox-elem", "passwdInput")
	if (!passwdInputEle)
	{
		logError("Does not find the pwd input ele in login page.")
		return false
	}
	accountInputEle := findIEElementByTwoAttr(inputElements, "type", "text", "data-loginbox-elem", "emailInput")
	if (!accountInputEle)
	{
		logError("Does not find the account input ele in login page.")
		return false
	}
	inputedAccount := SetInputEleValue(accountInputEle, loginName)
	inputedPasswd := SetInputEleValue(passwdInputEle, loginPwd)
	if (!inputedAccount)
	{
		logError("Failed set account in account input ele in login page.")
		return false
	}
	if (!inputedPasswd)
	{
		logError("Failed set pwd in account input ele in login page.")
		return false
	}
	;if exists vcode
	spanElements := loginPage.document.getElementsByTagName("span")
	vcodeEle := findIEElement(spanElements, "data-loginbox-elem", "piccode")
	if (EleExistsAndDisplay(vcodeEle))
	{
		;
		vcodeInputEle := findIEElementByTwoAttr(inputElements, "type", "text", "data-loginbox-elem", "piccodeInput")
		if (!EleExistsAndDisplay(vcodeInputEle))
		{
			return false
		}
		
		;enterVcode(pageWb, imgEle, inputVcodeEle)
		enterVcode(loginPage, vcodeEle, vcodeInputEle)
		;click login
		;input
	}
;	if vcodeExists()
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
					return true
				}						
				break
			}
		}
	}
	return false
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
						return true
					}						
					break
				}
			}
		}
	}
	return false
}
