#Include LoggerUtils.ahk
;exePath := "E:\source\cplusdemo\autohotkeyexe\autohotkeyexe\Release\autohotkeyexe.exe"
;localtest
;~ exePath := "D:\sources\github\autohotkey-vcode\Release\dll.exe"
;exePath := "C:\auto\vcode\dll.exe"

mouseMoveByPython()
{
  global pythonMouseMoveExePath
  Run , %pythonMouseMoveExePath%,,Hide
  Sleep 500
}

distinctVcode(vcodeImgPath, vcodeResultPath)
{
  global exePath
  Run,  %exePath% %vcodeImgPath% %vcodeResultPath%,,Hide
  Loop, 60
  {
    IfNotExist, %vcodeResultPath%
    {
      Sleep 1000
    }
    else
    {
      break
    }
  }
  Sleep 1000
  IfNotExist, %vcodeResultPath%
  {
    logError("Not found the vcode result file " . vcodeResultPath . " after distinct vcode by img path:" . vcodeImgPath)
    return
  }
  FileReadLine, distinctStatus, %vcodeResultPath%, 1
  if ErrorLevel
  {
    logError("Read distinct vcode img result path . vcodeResultPath . failed. ")
    return
  }
  if (distinctStatus != 0)
  {
    FileReadLine, info, %vcodeResultPath%, 2
    if ErrorLevel
    {
      logError("Read distinct vcode img result path . vcodeResultPath . failed. ")
      return
    }
    logError("Distinct vcode img path failed. Info:" . info)
    return
  }
  FileReadLine, vcode, %vcodeResultPath%, 3
  return vcode
}
