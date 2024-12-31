; AHK v1.1 script

#Include gpt.ahk
#Include latex.ahk
#Include screenrec.ahk

Return

; ---------------------------------------------------------------------
; Pseudoclipboard
; ---------------------------------------------------------------------


; DORMANT FOR NOW.
Insert & C::
	if GetKeyState("Ctrl", "P")
	{
		Menu, Tray, Icon, %SystemRoot%\system32\imageres.dll, 77
		Input, PCLP, B M, {Enter}
		Menu, Tray, Icon, %A_AhkPath%, 0
	} else {
		PCLP := clipboard
	}
	Return


Insert & V::	
	SendInput, %PCLP%
	Return

; ---------------------------------------------------------------------
; CONVENIENCE MAPPINGS
; ---------------------------------------------------------------------




^+CapsLock:: Enter	; Ctrl+CapsLock is an Enter: Left side ftw
+CapsLock:: CapsLock	; Shift+CapsLock works as CapsLock now
CapsLock:: BackSpace	; In particular, ctrl+capslock, etc. as well.
	

^Numpad0::	; Yet another backspace 
	Send, {Backspace}
	Return
^!Numpad0::
	Send, {^Backspace}
	Return

Insert & CapsLock::
	Click
	Return

!PgUp::
	SendInput, {Up 10}
	Return

!PgDn::
	SendInput, {Down 10}
	Return

; ---------------------------------------------------------------------
; BASC FUNCTIONS
; ---------------------------------------------------------------------


^!+BackSpace::
	ToolTip, PROCESS_KILL
	Input, PCLP, , {Enter}
	ToolTip, %PCLP%
	Run, taskkill /im %PCLP%.exe /f /t
	Sleep 1000
	ToolTip	
	Return

Browser_Search::
	Run, e:\obsidian\obsidian.exe
	Return
^Browser_Search::
	Process, Close, obsidian.exe
	Return

Launch_Mail::
	Run, F:\Telegram Desktop\Telegram.exe
	Return

^Launch_Mail::
	Process, Close, telegram.exe
	Return

^Browser_Home::
	Process, Close, chrome.exe
	Return

^+Browser_Home::
	ToolTip, Will close Chrome in two minutes.
	Sleep, 750
	ToolTip,
	Sleep, 120000
	Process, Close, chrome.exe
	Return


+Volume_Down::
	Run, explorer f:\aban\#\telegram
	Return
+Volume_Up::
	Run, explorer f:\aban\music
	Return

; ---------------------------------------------------------------------
; Script management
; ---------------------------------------------------------------------

Insert & 0::
#If WinActive("ahk_class Notepad")
^r::
	MsgBox, OK
	Reload
	Return
#If

Insert & n::
	Run, notepad
	Return

Insert & w::
	Run, notepad f:\aban\lab\.ahk\daemon.ahk
	Return

Insert & q::
	Run, pythonw -m idlelib.idle
	Return

Insert & 2::
	Run, cmd /k cd ..
	Return

Insert & 1::
	Run, pwsh
	Return
