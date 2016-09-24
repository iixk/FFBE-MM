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
			Msgbox Open Nox and press F1.
			keywait, F1, D T60
			if errorlevel
			{
				msgbox Timed Out`nScript will exit.
				exitapp
			}
			else
			{
				GetWinInfo()
				if MiddleX != 300 || MiddleY != 495
				{
					Msgbox, 4, , Window size different.`n`nResize Window?
					IfMsgBox, yes
					{
						WinGetClass, wintitle, A
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
			}
				
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
	IniRead, Energy, %A_ScriptDir%/data/Explorations/%Exploration%.ini, Exploration, Energy
	IniRead, PB_Token, %A_ScriptDir%/data/config/config.ini, PushBullet, API
	WinGet, winid, ID, ahk_class %wintitle%
	EnergyTimer := Energy * 300000
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
				if A_Index > MaxRotate
				{
					MaxRotate := %A_Index%
				}
				loadExp%A_Index% = %A_LoopFileName%
			}
			LoadedExp := 1
		}
		if !Rotate
		{
			Rotate := 1
		}
		read := loadExp%Rotate%
		IniRead, newExp, %A_ScriptDir%/data/Explorations/%read%, Exploration, Title
			if newExp = %Exploration%
			{
				SelectExp()
				return
			}
			else
			{
				IniWrite, %newExp%, %A_ScriptDir%/data/config/config.ini, Exploration, Current
				IniWrite, %read%, %A_ScriptDir%/data/config/config.ini, Exploration, File
				Exploration = %newExp%
				IniRead, Energy, %A_ScriptDir%/data/Explorations/%Exploration%.ini, Exploration, Energy
				EnergyTimer := %Energy% * 300000
			}
		Rotate += 1
		if Rotate > MaxRotate
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