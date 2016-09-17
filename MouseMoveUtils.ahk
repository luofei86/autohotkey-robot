;name MouseMoveUtils.ahk

findPos(el) {
    if (el.getBoundingClientRect)
	{
        return el.getBoundingClientRect()
	}
    else {
        x = 0, y = 0
        loop
        {
            x += el.offsetLeft - el.scrollLeft
            y += el.offsetTop - el.scrollTop
        } until (el = el.offsetParent)
        return "left:" x ", " "top:" y
    }      
}

moveToPos(left, top)
{
	MouseGetPos, xpos, ypos
	mouseMoveX := left - xpos
	mouseMoveY := top - ypos +5
	MouseMove, mouseMoveX, mouseMoveY, 50, R
}

;pWin will throw e catch it and handle with default
moveToPosWithBottom(ele, pWin)
{
	screenLeft := _getPwinScreenLeft(pWin)
	MouseGetPos, xpos, ypos
	pos := findPos(ele)
	mouseGoToX := pos.left + screenLeft  + 30
	mouseGoToY := pos.bottom + + pos.top -5
	mouseMoveX := mouseGoToX - xpos
	mouseMoveY := (mouseGoToY - ypos)
	MouseMove, mouseMoveX, mouseMoveY, 50, R
	MouseClick, left
	Sleep 1000
}

_getPwinScreenLeft(pWin)
{
	try
	{
		return pWin.screenLeft 
	}
	catch
	{
		global defaultScreenLeft
		return defaultScreenLeft
	}
}