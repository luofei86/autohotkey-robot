;iqiyi account login logout

#Include IqiyiVcode.ahk

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
logoutFromHomepage(homepageWb)
{
	if (homepageWb)
	{
		userLoginDiv := getUserLoginedDiv(homepageWb)
		
		if (userLoginDiv)
		{
			MsgBox "Find log out div"
			userLoginDiv.click()
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
		return loginText = "登录"
	}catch
	{
		return False
	}
}

loginFromHomepage(homepageWb, loginName, loginPwd)
{
	if (homepageWb)
	{
		MsgBox "Pop login div"
		homepageWb.document.getElementById("widget-userregistlogin").getElementsByTagName("div")[3].getElementsByTagName("div")[0].getElementsByTagName("a")[0].click()
		Sleep 2000
		popLoginDiv := homepageWb.document.getElementById("qipaLoginIfr")
		if popLoginDiv
		{
			loginByPopDiv(homepageWb, loginName, loginPwd)
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

