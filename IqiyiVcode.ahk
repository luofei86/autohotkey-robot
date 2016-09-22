;input iqiti login vcode
#Include MouseMoveUtils.ahk
#Include IEDomUtils.ahk
#Include WinExe.ahk

enterVcode(pageWb, imgEle, inputVcodeEle)
{
	global vcodeImgPath
	IEPageActive(pageWb)
	Sleep 2000
	pWin := pageWb.Document.ParentWindow
	pwinLeft := _getPwinLeft(pWin)
	pwinTop := _getPwinTop(pWin)
	moveToVcodeImg(imgEle, pwinLeft, pwinTop)
	imgFileName :=% A_Now
	imgPath :=  vcodeImgPath . imgFileName . ".png"
	saveVcodeImg(imgPath)
	IfNotExist, %imgPath%
	{
		MouseGetPos, mouseX, mouseY
		logError("The mouse pos x:" . mouseX . ", y:" . mouseY)
		logError("Save vcode img " . imgPath . " failed.")
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

_getPwinLeft(pwin)
{
	try
	{
		screenLeft := pWin.screenLeft
		return screenLeft
	}
	catch
	{
		global pwinLeft
		return pwinLeft
	}
}

_getPwinTop(pwin)
{
	try
	{
		screenTop := pWin.screenTop
		return screenTop
	}
	catch
	{
		global pwinTop
		return pwinTop
	}
}


moveToVcodeImg(vcodeEle, pwinLeft, pwinTop)
{
	vcodeElePos := findPos(vcodeEle)
	gotoX := vcodeElePos.left + (135/2) + pwinLeft
	gotoY := vcodeElePos.top + (36/2) + pwinTop
	MouseGetPos, x, y
	mouseMoveX := gotoX -x
	mouseMoveY := gotoY - y
	MouseMove, mouseMoveX, mouseMoveY, 100, R
	Sleep 2000
}

saveVcodeImg(imgPath)
{
	MouseClick, click
	Sleep 1500
	MouseClick, right
	Sleep 1500
	Send {s}
	Sleep 3000
	Send %imgPath%
	Sleep 1000
	Send {Enter}
	Sleep 3000
}
