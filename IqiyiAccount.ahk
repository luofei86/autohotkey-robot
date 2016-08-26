;iqiyi account login logout

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
logoutFromHomePage(homepageWb)
{
	if (homepageWb)
	{
		userLoginDiv := homepageWb.document.getElementById("top-username")
		
		if (userLoginDiv)
		{
			;MsgBox "Find log out div"
			userLoginDiv.click()
			popDiv := homepageWb.document.getElementById("nav-login-info")
			try
			{
				popDiv.getElementsByTagName("div")[0].getElementsByTagName("div")[0].getElementsByTagName("div")[0].getElementsByTagName("div")[1].getElementsByTagName("a")[3].click()
			}
			catch{}
		}
		
	}
}