; Example: Make an asynchronous HTTP request.

req := ComObjCreate("Msxml2.XMLHTTP")
; Open a request with async enabled.
req.open("GET", "http://iosapi.appchina.com/app/detail.json?channel=&rootid=1", true)
; Set our callback function (v1.1.17+).
req.onreadystatechange := Func("Ready")
; Send the request.  Ready() will be called when it's complete.
req.send()
/*
; If you're going to wait, there's no need for onreadystatechange.
; Setting async=true and waiting like this allows the script to remain
; responsive while the download is taking place, whereas async=false
; will make the script unresponsive.
while req.readyState != 4
    sleep 100
*/
#Persistent

Ready() {
    global req
    if (req.readyState != 4)  ; Not done yet.
        return
    if (req.status == 200 || req.status == 304) ; OK.
        MsgBox % "Latest AutoHotkey version: " req.responseText
    else
        MsgBox 16,, % "Status " req.status
    ExitApp
}