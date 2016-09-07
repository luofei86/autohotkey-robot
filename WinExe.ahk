;~ CMDout=
;~ CMDerr=
;~ ProgramName := "E:\source\cplusdemo\autohotkeyexe\autohotkeyexe\Release\autohotkeyexe.exe"

;~ Ret := RunWaitEx(ProgramName, NULL, TextIn, CMDout, CMDerr)
;~ MsgBox, Return Value: %Ret% `r`n`r`nStdError: `r`n%CMDerr%`r`nStdOutput: `r`n%CMDout%

;~ RunWaitEx(CMD, CMDdir, CMDin, ByRef CMDout, ByRef CMDerr)
;~ {
  ;~ VarSetCapacity(CMDOut, 100000)
  ;~ VarSetCapacity(CMDerr, 100000)
  ;~ RetVal := DllCall("cmdret.dll\RunWEx", "str", CMD, "str", CMDdir, "str", CMDin, "str", CMDout, "str", CMDerr)
  ;~ Return, %RetVal%
;~ }


;~ ret1 := CMDret("E:\source\cplusdemo\autohotkeyexe\autohotkeyexe\Release\autohotkeyexe.exe")

;~ MsgBox, Result: *%ret1%*

;~ CMDret(CMD)
;~ {
  ;~ VarSetCapacity(StrOut, 10000)
  ;~ RetVal := DllCall("cmdret.dll\RunReturn", "str", CMD, "str", StrOut)
  ;~ Return, %StrOut%
;~ }

run , E:\source\cplusdemo\autohotkeyexe\autohotkeyexe\Release\autohotkeyexe.exe C:\vcode\1.png C:\vcode\1.txt
;run , "E:\source\cplusdemo\autohotkeyexe\autohotkeyexe\Release\autohotkeyexe.exe C:\vcode\1.png C:\vcode\1.txt" 

getVcode("C:\vcode\1.png", "C:\vcode\1.txt")

getVcode(vcodeImgPath, vcodeResultPath)
{
	run , E:\source\cplusdemo\autohotkeyexe\autohotkeyexe\Release\autohotkeyexe.exe vcodeImgPath vcodeResultPath
}
