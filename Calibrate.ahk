------
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force ; only one instance of script can run
#Persistent ; to make it run indefinitely

SetMouseDelay, 25
SendMode Input 
CoordMode, Mouse, Relative
SetControlDelay -1
SetFormat, float, 0

Global wintitle
Global wintext
Global MiddleX
Global MiddleY
Global Up
Global Down
Global Left
Global Right
Global Exploration

Exploration:=%A_ScriptDir%/data/Explorations/Dwarfs Forge.ini

^1::TestPixel()
F1::Calibrate()
f11::
{
	Msgbox, 4, , Going to try and resize emulator to fix pathing.`nContinue?
	IfMsgBox, no
		return
	IfMsgBox, yes
	{
		WinGetClass, wintitle, A
		WinMove, ahk_class %wintitle%,,,, 600, 990
		GetWinInfo()
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
f12::reload ;reloads script if an error occurs

TestPixel()
{
	MouseGetPos, mX, mY
	PixelGetColor, c, mX, mY, RGB
	GetWinInfo()
	Tooltip %mX% - %mY% -- %c%
}

Calibrate()
{
	IfNotExist, %A_ScriptDir%/data/Config
	{

		FileCreateDir, %A_ScriptDir%/data/config
	}
	IfNotExist, %A_ScriptDir%/data/config/config.ini
	{
	GetWinInfo()
	IniWrite, %Exploration%, %A_ScriptDir%/data/config/config.ini, Exploration, Current
	IniWrite, %wintitle%, %A_ScriptDir%/data/config/config.ini, Window, WinTitle
	IniWrite, %wintext%, %A_ScriptDir%/data/config/config.ini, Window, WinText
	IniWrite, %MiddleX%, %A_ScriptDir%/data/config/config.ini, Window, MiddleX
	IniWrite, %MiddleY%, %A_ScriptDir%/data/config/config.ini, Window, MiddleY
	IniWrite, %Up%, %A_ScriptDir%/data/config/config.ini, Window, Up
	IniWrite, %Down%, %A_ScriptDir%/data/config/config.ini, Window, Down
	IniWrite, %Left%, %A_ScriptDir%/data/config/config.ini, Window, Left
	IniWrite, %Right%, %A_ScriptDir%/data/config/config.ini, Window, Right
	}

	GetWinInfo()
	IniRead, twintext, %A_ScriptDir%/data/config/config.ini, Window, WinText
	IniRead, tMiddleX, %A_ScriptDir%/data/config/config.ini, Window, MiddleX
	IniRead, tMiddleY, %A_ScriptDir%/data/config/config.ini, Window, MiddleY

	if ( twintext != wintext) || ( tMiddleX != MiddleX ) || ( tMiddleY != MiddleY)
	{
		ResetWinInfo()
	}
	
	x := 1
	YMax := MiddleY * 1.95
	YMin := MiddleY * 1.88
	XMax := MiddleX * .4
	XMin := MiddleX * .08
	While x < 6
	{
		MouseGetPos, mX, mY
		PixelGetColor, c, mX, mY, RGB
		YOK := 0
		YTEST := MiddleY * 1.88
		XOK := 0
		tooltip %wintext% a Move your mouse back and forth over the [AUTO] button.`nCalibrating [AUTO] Point %x% / 5...`n%mX% - %mY% %c%, 0, 0
		if ( mY > YMin ) && ( mY < YMax ) && ( mX < XMax ) && ( mX > XMin )
		{
			if c = 0xFFFFFF
			{
				IniWrite, %mX%, %A_ScriptDir%/data/config/config.ini, Pixels, AX%x%
				IniWrite, %mY%, %A_ScriptDir%/data/config/config.ini, Pixels, AY%x%
				Sleep, 1000
				x := x + 1
			}
		}
	}

	x := 1
	XMax := MiddleX * 1.92
	XMin := MiddleX * 1.53
	While x < 6
	{
		MouseGetPos, mX, mY
		PixelGetColor, c, mX, mY, RGB
		tooltip Move your mouse back and forth over the [MENU] button.`nCalibrating [MENU] Point %x% / 5...`n%mX% - %mY% %c%, 0, 0
		if ( mY > YMin ) && ( mY < YMax ) && ( mX < XMax ) && ( mX > XMin )
		{
				if c = 0xFFFFFF
				{
					IniWrite, %mX%, %A_ScriptDir%/data/config/config.ini, Pixels, MX%x%
					IniWrite, %mY%, %A_ScriptDir%/data/config/config.ini, Pixels, MY%x%
					Sleep, 1000
					x := x + 1
				}
		}
	}

	x := 1
	XMax := MiddleX * .93
	XMin := MiddleX * .55
	While x < 6
	{
		MouseGetPos, mX, mY
		PixelGetColor, c, mX, mY, RGB
		tooltip Move your mouse back and forth over the [REPEAT] button.`nCalibrating [REPEAT] Point %x% / 5...`n%mX% - %mY% %c%, 0, 0
		if ( mY > YMin ) && ( mY < YMax ) && ( mX < XMax ) && ( mX > XMin )
		{
			if c = 0xFFFFFF	;0x646464
			{
				IniWrite, %mX%, %A_ScriptDir%/data/config/config.ini, Pixels, RX%x%
				IniWrite, %mY%, %A_ScriptDir%/data/config/config.ini, Pixels, RY%x%
				Sleep, 1000
				x := x + 1
			}
		}
	}
	tooltip
	msgbox Calibration Complete.`nOk to run main script.
	exitapp
}

ResetWinInfo()
{
	Msgbox, 4, , Your window has changed from [%twintext%] to [%wintext%].`nAre you sure you want to configure with this new window?
	IfMsgBox, No
		exitapp
	IfMsgBox, Yes
	{
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