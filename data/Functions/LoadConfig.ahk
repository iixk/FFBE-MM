Global wintitle
Global wintext
Global MiddleX
Global MiddleY
Global Up
Global Down
Global Left
Global Right
Global Exploration
Global EnergyTimer
Global Rotate
Global winid
Global PB_Token
Global DebugOn
Global ExpFile
Global LoadedExp

LoadConfig()
{
	IfNotExist, %A_ScriptDir%/data/config/config.ini
	{
		Msgbox, 4, , Config File not found.`n`nCreate new config file?
		IfMsgBox, no
			exitapp
		IfMsgBox, yes
		{
			FileCreateDir, %A_ScriptDir%/data/config
			Msgbox Open Nox and press OK.
			Sleep, 1000
			WinActivate, ahk_class Qt5QWindowIcon
			GetWinInfo()
			if MiddleX != 300 || MiddleY != 495
			{
				Msgbox, 4, , Window size different.`n`nResize Window?
				IfMsgBox, yes
				{
					WinMove, ahk_class %wintitle%,,,, 600, 990
					GetWinInfo()
				}
			}
			IniWrite, NA, %A_ScriptDir%/data/config/config.ini, Exploration, Current
			IniWrite, %wintitle%, %A_ScriptDir%/data/config/config.ini, Window, WinTitle
			IniWrite, %wintext%, %A_ScriptDir%/data/config/config.ini, Window, WinText
			IniWrite, %MiddleX%, %A_ScriptDir%/data/config/config.ini, Window, MiddleX
			IniWrite, %MiddleY%, %A_ScriptDir%/data/config/config.ini, Window, MiddleY
			IniWrite, %Up%, %A_ScriptDir%/data/config/config.ini, Window, Up
			IniWrite, %Down%, %A_ScriptDir%/data/config/config.ini, Window, Down
			IniWrite, %Left%, %A_ScriptDir%/data/config/config.ini, Window, Left
			IniWrite, %Right%, %A_ScriptDir%/data/config/config.ini, Window, Right
			IniWrite, % "", %A_ScriptDir%/data/config/config.ini, PushBullet, PB_Token
			IniWrite, % "" , %A_ScriptDir%/data/config/config.ini, Debug, Debug	
		}
	}
	IniRead, wintitle, %A_ScriptDir%/data/config/config.ini, Window, WinTitle
	IniRead, wintext, %A_ScriptDir%/data/config/config.ini, Window, WinText
	IniRead, MiddleX, %A_ScriptDir%/data/config/config.ini, Window, MiddleX
	IniRead, MiddleY, %A_ScriptDir%/data/config/config.ini, Window, MiddleY
	IniRead, Up, %A_ScriptDir%/data/config/config.ini, Window, Up
	IniRead, Down, %A_ScriptDir%/data/config/config.ini, Window, Down
	IniRead, Left, %A_ScriptDir%/data/config/config.ini, Window, Left
	IniRead, Right, %A_ScriptDir%/data/config/config.ini, Window, Right
	IniRead, Exploration, %A_ScriptDir%/data/config/config.ini, Exploration, Current
	IniRead, ExpFile, %A_ScriptDir%/data/config/config.ini, Exploration, File
	IniRead, Energy, %A_ScriptDir%/data/Explorations/%ExpFile%, Exploration, Energy
	IniRead, PB_Token, %A_ScriptDir%/data/config/config.ini, PushBullet, API
	IniRead, DebugOn, %A_ScriptDir%/data/config/config.ini, Debug, Debug
	WinGet, winid, ID, ahk_class %wintitle%
	EnergyTimer := Energy * 300000
	
	IfNotExist, %A_ScriptDir%/data/img/					;begin image calibration
	{
		FileCreateDir, %A_ScriptDir%/data/img
	}
	count:=0
	Loop, Files, %A_ScriptDir%\data\img\*.png, R
	{
		if A_LoopFileName in step1.png,step2.png,step3.png,ic1.png,ic2.png,reward1.png
		{
			count+=1
		}
	}
	if count != 6
	{
		Msgbox, 4, , Error: Missing image files. (Count:%count%) `n`n Run calibration?
		IfMsgBox, no
			exitapp
		IfMsgBox, yes
		{
			Msgbox, Goto first screen of Earth Shrine and click OK.
			ProcessSteps("Calibrate")
			Msgbox, Step 1 Complete.`n`nHit F9 to select [Earth Shrine Exp] then F8 to start.`nWatch for popups on first run.
		}
	}
	return
}

SelectExp()
{
	tooltip Exploration Path Selected: [%Exploration%]`nPress [F9] to change.,0,0
	keywait, F9, D T3
	if errorlevel
	{
		tooltip
		return
	}
	else
	{
		if !LoadedExp
		{
			Loop, Files, %A_ScriptDir%/data/Explorations/*.ini
			{

				if !LoadedExp
				{
					LoadedExp = %A_LoopFileName%
				}
				else
				{
					LoadedExp = %LoadedExp%,%A_LoopFileName%
				}

			}
		}
		if !Rotate
		{
			Rotate := 1
		}
		StringSplit, Exp, LoadedExp, `,
		read := Exp%Rotate%
		if read
		{
		IniRead, newExp, %A_ScriptDir%/data/Explorations/%read%, Exploration, Title
			if newExp != %Exploration%
			{
				IniWrite, %newExp%, %A_ScriptDir%/data/config/config.ini, Exploration, Current
				IniWrite, %read%, %A_ScriptDir%/data/config/config.ini, Exploration, File
				Exploration = %newExp%
				IniRead, Energy, %A_ScriptDir%/data/Explorations/%Exploration%.ini, Exploration, Energy
				EnergyTimer := %Energy% * 300000
			}
		Rotate += 1
		}
		else
		{
			Rotate := 1
		}
		Sleep, 500
		SelectExp()
		return
	}
}

GetWinInfo()
{
	WinGetTitle, wintext, A
	WinGetClass, wintitle, A
	WinGetPos,,, w, h, ahk_class %wintitle%
	MiddleX := w / 2
	MiddleY := h / 2
	Up := MiddleY * .1
	Down := MiddleY * 1.975
	Left := MiddleX * .075
	Right := MiddleX * 1.925
}