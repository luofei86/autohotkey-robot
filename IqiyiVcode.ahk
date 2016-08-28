;input iqiti login vcode
#Include MouseMoveUtils.ahk


enterVcode(homepageWb)
{
	pWin := homepageWb.document.parentWindow
	;MsgBox "Move to img"
	moveToImg(homepageWb, pWin)
	saveVcodeImg()
	Sleep 500
	distinguishVcode()
	;
	Send {Enter}
}

distinguishVcode(vcodePath := "")
{
	Sleep 10000
	return True
}

saveVcodeImg()
{
	Sleep 2000			
	MouseClick, right
	Sleep 1000
	Send {s}
	Sleep 500
	fileName := % A_Now
	Send {%fileName%}
	Sleep 500
	Send {Enter}
	Sleep 500
	Send {Tab}
	Sleep 500
	Send {Enter}
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
