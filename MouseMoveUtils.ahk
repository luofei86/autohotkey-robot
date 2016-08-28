
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
