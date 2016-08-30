homeUrl := "http://www.iqiyi.com/"
#Include IEDomUtils.ahk
#Include LoggerUtils.ahk
;homeUrl := "about:tabs"
;homePageWb := gotoHomepage("about:tabs")

gotoHomepage()
{
	global homeUrl
	homePageWb := ComObjCreate("InternetExplorer.Application") ;create a IE instance
	homePageWb.Visible := True
	homePageWb.Navigate(loadUrl)
	WinMaximize, % "ahk_id " homePageWb.HWND
	Sleep 200
	IEDomWait(homePageWb)
	logInfo("Loaded iqiyi homepage")
	return homePageWb
}

;random access the homepage to Confuse the server
fuzzyUserRandomAccessWebsite(homepageWb)
{
	
}