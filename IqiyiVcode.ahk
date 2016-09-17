;input iqiti login vcode
#Include MouseMoveUtils.ahk
#Include IEDomUtils.ahk
#Include WinExe.ahk

;~ vcodeImgPath := "C:\vcode\"

enterVcode(pageWb, imgEle, inputVcodeEle)
{
	global vcodeImgPath
	IEPageActive(pageWb)
	Sleep 500
	pWin := pageWb.document.parentWindow
	moveToImgEle(pWin, imgEle)
	imgFileName :=% A_Now
	imgPath :=  vcodeImgPath . imgFileName . ".png"
	saveVcodeImg(imgPath)
	IfNotExist, %imgPath%
	{
		logError("Save vcode img failed.")
		return false
	}
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
	mouseGoToX := pos.left + pWin.screenLeft  + 30
	mouseGoToY := pos.top + pWin.screenTop + 30
	MouseGetPos, xpos, ypos 
	mouseMoveX := mouseGoToX - xpos
	mouseMoveY := mouseGoToY - ypos
	MouseMove, mouseMoveX, mouseMoveY, 50, R
	return true
}

moveToImg(homepageWb, pWin)
{
	tableEles := homepageWb.document.getElementsByTagName("table")
	table := findIEElement(tableEles, "data-loginbox-elem", "loginTable")
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
				img := images[0]
				pos := findPos(img)
				mouseGoToX := pos.left + pWin.screenLeft  + 30
				mouseGoToY := pos.top + pWin.screenTop + 30
				mouseMoveX := mouseGoToX - xpos
				mouseMoveY := mouseGoToY - ypos
				MouseMove, mouseMoveX, mouseMoveY, 50, R
				return true
			}			
		}
	}
	return false
}
