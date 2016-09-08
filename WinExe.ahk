#Include LoggerUtils.ahk
exePath := "E:\source\cplusdemo\autohotkeyexe\autohotkeyexe\Release\autohotkeyexe.exe"
exePath := "D:\sources\github\autohotkey-vcode\Release"

distinctVcode(vcodeImgPath, vcodeResultPath)
{
  global exePath
  Run,  %exePath% %vcodeImgPath% %vcodeResultPath%,,Hide
  Loop, 5
  {
    IfNotExist, %vcodeResultPath%
    {
      Sleep 1000
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
