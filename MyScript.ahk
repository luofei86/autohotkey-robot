^j::
   MsgBox Wow!
   MsgBox this is
   Run, Notepad.exe
   winactivate, 无标题 - 记事本
   WinWaitActive, 无标题 - 记事本
   send, 7 lines{!}{enter}
   sendinput, inside the ctrl{+}j hotkey
Return