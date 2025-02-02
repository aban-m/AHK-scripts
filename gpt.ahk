; AHK v1.1 Script
global temperature := 0.7
global max_tokens := 250
global model := "gpt-4o"

system_prompts := ["Answer in code. No comment, no markdown, just code. if Latex, delimit with $$. assume python by default. do not import libraries, do not give example.", "Respond in powershell code, no comment and no markdown, just code. It will be executed as-is.", "", "", "", "", "", "", "You are a helpful assistant. Give brief answers.", "correct my language as is, no modifications. if the text is in different language, just translate to english as is."]

global system_prompt := system_prompts[8]

#Include util.ahk

Return

; ---------------------------------------------------------------------
; GPT
; ---------------------------------------------------------------------

Insert & PgUp::
	If GetKeyState("Shift", "P")
	{
		temperature += 0.1
		ToolTip, Temperature: %temperature%
	}
	Else
	{
		max_tokens += 10
		ToolTip, Max tokens: %max_tokens%
	}
	Sleep 400
	ToolTip,
	Return

 

Insert & PgDn::
	If GetKeyState("Shift", "P")
	{	
		temperature -= 0.1
		ToolTip, Temperature: %temperature%
	}
	Else
	{
		max_tokens -= 10
		ToolTip, Max tokens: %max_tokens%
	}
	Sleep 400
	ToolTip,
	Return
   
Insert & G::
	If GetKeyState("Up", "P") {
		model := "gpt-4o"
		SoundBeep
		MsgBox, Current model: %model%
		Return
	}
	If GetKeyState("Down", "P") {
		model := "gpt-4o-mini"
		MsgBox, Current model: %model%
		Return
	}
	If GetKeyState("Space", "P") {
		If GetKeyState("Shift", "P") { 
			MsgBox, %system_prompt%
			Return
		}
		If GetKeyState("Control", "P") {
			ToolTip, INDEX_WAIT
			Input, userChar, L1
			index := Asc(userChar) - 48
			system_prompt := system_prompts[index + 1]
			ToolTip, %system_prompt%
			Sleep 1000
			ToolTip, 
			Return
		}
		system_prompt := clipboard
		ToolTip, Set system clipboard: %system_prompt%
		Sleep 1000
		ToolTip, 
		Return
	}
	to_msg := GetKeyState("Shift", "P")
	to_out := GetKeyState("Alt", "P")
	enhance := !GetKeyState("Control", "P") 
	input := " "
	if enhance {
		ToolTip, WAITING FOR INPUT
		Input, input,  , {Enter}
		if (substr(input, 0) = ":") {
			input := input . " " . clipboard
		}
	} else { 
	 	input := clipboard
	} 
	input := StrReplace(input, """", "'")
        if (substr(input, 0) = "-") {
		ToolTip, Aborted!
		Sleep 550
		ToolTip,
		Return
	}
	command := "gptd --message """ input """ --model " model " --max_tokens " max_tokens " --temperature " temperature " --system_prompt """ system_prompt """"
	ToolTip, Waiting for response...
	output := Trim(RunCMD(command), "`n")
	ToolTip
	If to_msg {
		MsgBox, %output%
	}
	Else If to_out {
		SendRaw, %output%
	}
	Else {
		clipboard := output
	}
	Return
