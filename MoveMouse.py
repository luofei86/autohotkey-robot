import sys
import os
from inspect import getsourcefile
from os.path import abspath
import win32api, win32con

####get pwin top pwin left from file
####get vcode ele position from file
####cal the mouse need to move
####move it

	# MouseGetPos, x, y
	# mouseMoveX := gotoX -x
	# mouseMoveY := gotoY - y
	# logInfo("Current mouse x:" . x . ", y:" . y . ", current ele x:" . vcodeElePos.left . ", y:" . vcodeElePos.top . ", current pwin left:" . pwinLeft . ", pwin top:" . pwinTop . ", then move mouse x" . mouseMoveX . ", y:" . mouseMoveY)
	# MouseMove, mouseMoveX, mouseMoveY, 100, R
def we_are_frozen():
	return hasattr(sys, "frozen")



encoding = sys.getfilesystemencoding()
if we_are_frozen():
	exePath = os.path.dirname(unicode(sys.executable, encoding))
else:
	exePath = os.path.dirname(unicode(__file__, encoding))

exePath = abspath(getsourcefile(lambda:0))
# print "My path: %s" %(exePath)
rightIndex = exePath.rfind("\\")
# print "My path last dir index: %d" %(rightIndex)
if(rightIndex):
	pathDir = exePath[0:rightIndex]
# print "My path dir: %s" %(pathDir)
mouseMovePath = pathDir + "\\mousepos.txt"
# print "My path path: %s" %(mouseMovePath)
# print "OK"
try:
	for line in open(mouseMovePath):
		line = line.rstrip()
		xIndex = line.find("x:")
		if (xIndex>=0):
			mouseX = line[2:]
		else:
			yIndex = line.find("y:")
			if(yIndex >=0):
				mouseY = line[2:]
	if(mouseX and mouseY):
		mouseX = int(round(float(mouseX)))
		mouseY = int(round(float(mouseY)))

		win32api.SetCursorPos((mouseX, mouseY))
except Exception, e:
	print e
# print "Movex:%s, Movey:%s" %(mouseX, mouseY)


	# MouseGetPos, x, y
	# mouseMoveX := gotoX -x
	# mouseMoveY := gotoY - y
	# logInfo("Current mouse x:" . x . ", y:" . y . ", current ele x:" . vcodeElePos.left . ", y:" . vcodeElePos.top . ", current pwin left:" . pwinLeft . ", pwin top:" . pwinTop . ", then move mouse x" . mouseMoveX . ", y:" . mouseMoveY)
	# MouseMove, mouseMoveX, mouseMoveY, 100, R



# point = win32api.GetCursorPos()
# print "Current mouse x:%s, y:%s" %(point[0], point[1]) 

# mouseMoveX = int(moveX) - int(point[0])
# mouseMoveY = int(moveY) - int(point[1])
# print "Current mouse will move x:%s, y:%s" %(mouseMoveX, mouseMoveY)

# point = win32api.GetCursorPos()
# print "Current mouse x:%s, y:%s" %(point[0], point[1]) 
