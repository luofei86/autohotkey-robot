;input iqiti login vcode
#Include MouseMoveUtils.ahk
#Include IEDomUtils.ahk
#Include WinExe.ahk

vcodeImgPath := "C:\vcode\"

enterVcode(pageWb, imgEle, inputVcodeEle)
{
	global vcodeImgPath
	IEPageActive(pageWb)
	Sleep 500
	pWin := pageWb.document.parentWindow
	moveToImgEle(pWin, imgEle)
	imgFileName :=% A_Now
	imgFileName :=  vcodeImgPath . imgFileName . ".png"
	imgPath := saveVcodeImg(imgFileName)
	resultPath := vcodeImgPath . imgFileName . ".txt"
	vcode := distinctVcode(imgPath, resultPath)
	if (!vcode)
	{
		return false
	}
	IEPageActive(pageWb)
	Sleep 500
	SetInputEleValue(inputVcodeEle, vcode)
	Sleep 500
	return true
}

saveVcodeImg(imgFileName)
{
	Sleep 2000			
	MouseClick, right
	Sleep 1000
	Send {s}
	Sleep 500
	Send %imgFileName%
	Sleep 500
	Send {Enter}
	Sleep 3000
}

moveToImgEle(pWin, imgEle)
{
	pos := findPos(imgEle)
	;MsgBox % "Cur img Top:" (pos.top) " Left:" (pos.left) "Right:" (pos.right)
	mouseGoToX := pos.left + pWin.screenLeft  + 30
	mouseGoToY := pos.top + pWin.screenTop + 30
	MouseGetPos, xpos, ypos 
	mouseMoveX := mouseGoToX - xpos
	mouseMoveY := mouseGoToY - ypos
	;MsgBox % "Mouse move X:" (mouseMoveX) ", Mouse move Y:" (mouseMoveY)
	;MsgBox, 0, code img, %	"Left:	"		pos.left + pWin.screenLeft ; left side of element rectagle + left side of screen
	;							.	"`nTop:	"		pos.top + pWin.screenTop
	;							.	"`nRight:	"	pos.right + pWin.screenLeft
	;							.	"`nBottom:	"	pos.bottom + pWin.screenTop
	MouseMove, mouseMoveX, mouseMoveY, 50, R
	return true
}

moveToImg(homepageWb, pWin)
{
	table := homepageWb.document.getElementById("qipaLoginIfr").getElementsByTagName("div")[0].getElementsByTagName("div")[0].getElementsByTagName("div")[1].getElementsByTagName("table")[0]
	tbody := table.getElementsByTagName("tbody")[0]
	trs :=  tbody.getElementsByTagName("tr")
	if (trs && trs.length >=3)
	{
		dataElem := trs[2].getAttribute("data-loginbox-elem")		
		if (dataElem = "piccodeTr")
		{
			tds := trs[2].getElementsByTagName("td")
			divs := tds[0].getElementsByTagName("div")
			spans := divs[0].getElementsByTagName("span")
			images := spans[1].getElementsByTagName("img")
			if (images && images.length >0)
			{
				MouseGetPos, xpos, ypos 
				;MsgBox % "Cur mouse xpos:" (xpos) " ypos:" (ypos)
				;MsgBox % "pWin xpos:" (pWin.screenLeft) " ypos:" (pWin.screenTop)
				img := images[0]
				pos := findPos(img)
				;MsgBox % "Cur img Top:" (pos.top) " Left:" (pos.left) "Right:" (pos.right)
				mouseGoToX := pos.left + pWin.screenLeft  + 30
				mouseGoToY := pos.top + pWin.screenTop + 30
				mouseMoveX := mouseGoToX - xpos
				mouseMoveY := mouseGoToY - ypos
				;MsgBox % "Mouse move X:" (mouseMoveX) ", Mouse move Y:" (mouseMoveY)
				;MsgBox, 0, code img, %	"Left:	"		pos.left + pWin.screenLeft ; left side of element rectagle + left side of screen
				;							.	"`nTop:	"		pos.top + pWin.screenTop
				;							.	"`nRight:	"	pos.right + pWin.screenLeft
				;							.	"`nBottom:	"	pos.bottom + pWin.screenTop
				MouseMove, mouseMoveX, mouseMoveY, 50, R
				return True
			}			
		}
	}
	return False
}
