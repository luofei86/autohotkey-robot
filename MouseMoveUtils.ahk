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
	;MsgBox % "Move to X:" (left) ",Y:" (top)
	MouseGetPos, xpos, ypos
	;MsgBox % "Mouse X:" (xpos) ",Y:" (ypos)
	mouseMoveX := left - xpos
	mouseMoveY := top - ypos +5
	;MsgBox % "Moves X:" (mouseMoveX) ",Y:" (mouseMoveY)
	MouseMove, mouseMoveX, mouseMoveY, 50, R
}

moveToPosWithBottom(ele, pWin)
{
	MouseGetPos, xpos, ypos
	pos := findPos(ele)
	;MsgBox % "bottom:" (pos.bottom) ", left:" (pos.left) ", top:" (pos.top)
	;MsgBox , % A_ScreenHeight
	mouseGoToX := pos.left + pWin.screenLeft  + 30
	mouseGoToY := pos.bottom + + pos.top -5
	mouseMoveX := mouseGoToX - xpos
	mouseMoveY := (mouseGoToY - ypos)
	;MsgBox, % "Move x:" (mouseMoveX) ", Move Y:" (mouseMoveY)
	MouseMove, mouseMoveX, mouseMoveY, 50, R
	MouseClick, left
	Sleep 1000
}