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
