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
	moveToVcodeImgByPython(imgEle, pwinLeft, pwinTop)
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

moveToVcodeImgByPython(vcodeEle, pwinLeft, pwinTop)
{
	;mousepos.txt the soft comm with python by file
	global commPythonPath
	vcodeElePos := findPos(vcodeEle)
	gotoX := vcodeElePos.left + (135/2) + pwinLeft
	gotoY := vcodeElePos.top + (36/2) + pwinTop	
	mouseXFileStr := "x:" . gotoX . "`n"
	mouseYFileStr := "y:" . gotoY
	IfExist, %commPythonPath%
	{
		FileDelete, %commPythonPath%
	}
	FileAppend, %mouseXFileStr%, %commPythonPath%
	FileAppend, %mouseYFileStr%, %commPythonPath%	
	;exe move by python
	mouseMoveByPython(commPythonPath)
	Sleep 3000
	MouseGetPos, x, y
	logInfo("The ele pos x:" . gotoX . ", y:" . gotoY . ", the current mouse x:" . x . ", y:" . y . ".")
}

moveToVcodeImg(vcodeEle, pwinLeft, pwinTop)
{
	vcodeElePos := findPos(vcodeEle)
	CoordMode, Mouse, Screen
	gotoX := vcodeElePos.left + (135/2) + pwinLeft
	gotoY := vcodeElePos.top + (36/2) + pwinTop
	MouseGetPos, x, y
	mouseMoveX := gotoX -x
	mouseMoveY := gotoY - y
	logInfo("Current mouse x:" . x . ", y:" . y . ", current ele x:" . vcodeElePos.left . ", y:" . vcodeElePos.top . ", current pwin left:" . pwinLeft . ", pwin top:" . pwinTop . ", then move mouse x" . mouseMoveX . ", y:" . mouseMoveY)
	MouseMove, mouseMoveX, mouseMoveY, 100, R
	Sleep 2000
}

saveVcodeImg(imgPath)
{
	;~ MouseClick, left
	;~ Sleep 1500
	MouseClick, right
	Sleep 2000
	Send {s}
	Sleep 2000
	Send %imgPath%
	Sleep 2000
	Send {Enter}
	Sleep 3000
}
