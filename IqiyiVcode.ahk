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
	moveToVcodeImg()
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

moveToVcodeImg()
{
	global vcodex
	global vcodey
	MouseGetPos, mouseX, mouseY
	MouseMove, -mouseX, -mouseY, 50, R
	Sleep 500
	MouseMove, vcodex, vcodey, 50, R
	Sleep 500
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
