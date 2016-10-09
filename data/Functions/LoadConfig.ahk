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
Global ImgMethod
Global ImgFileOn
Global Energy
Global FightMode
Global SpendLapis
Global ImagePath
Global FightPath

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

			IniWrite, NA, %A_ScriptDir%/data/config/config.ini, Exploration, Current
			IniWrite, %wintitle%, %A_ScriptDir%/data/config/config.ini, Window, WinTitle
			IniWrite, %wintext%, %A_ScriptDir%/data/config/config.ini, Window, WinText
			IniWrite, %MiddleX%, %A_ScriptDir%/data/config/config.ini, Window, MiddleX
			IniWrite, %MiddleY%, %A_ScriptDir%/data/config/config.ini, Window, MiddleY
			IniWrite, %Up%, %A_ScriptDir%/data/config/config.ini, Window, Up
			IniWrite, %Down%, %A_ScriptDir%/data/config/config.ini, Window, Down
			IniWrite, %Left%, %A_ScriptDir%/data/config/config.ini, Window, Left
			IniWrite, %Right%, %A_ScriptDir%/data/config/config.ini, Window, Right
			IniWrite, % "" , %A_ScriptDir%/data/config/config.ini, ImageSearch, Method
			IniWrite, 1, %A_ScriptDir%/data/config/config.ini, ImageSearch, GilSearch
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
	IniRead, ImgMethod, %A_ScriptDir%/data/config/config.ini, ImageSearch, Method
	IniRead, ImgFileOn, %A_ScriptDir%/data/config/config.ini, ImageSearch, GilSearch
	IniRead, FightMode, %A_ScriptDir%/data/config/config.ini, FightMode, Method
	IniRead, SpendLapis, %A_ScriptDir%/data/config/config.ini, Options, SpendLapis
	
	;Cleanup new settings on old config files.
	if SpendLapis = ERROR
	{
		IniWrite, % "", %A_ScriptDir%/data/config/config.ini, Options, SpendLapis
		SpendLapis =
	}
	if FightMode = ERROR
	{
		IniWrite, % "", %A_ScriptDir%/data/config/config.ini, FightMode, Method
		FightMode =
	}
	if ImgFileOn = ERROR
	{
		IniWrite, 1, %A_ScriptDir%/data/config/config.ini, ImageSearch, GilSearch
		GilSearch := 1
	}
	if ImgMethod = ERROR
	{
		IniWrite, % "" , %A_ScriptDir%/data/config/config.ini, ImageSearch, Method
		ImageSearch =
	}
	if DebugOn = ERROR
	{
		IniWrite, % "" , %A_ScriptDir%/data/config/config.ini, Debug, Debug
		DebugOn =
	}
	
	;Set ImagePath for Alt. ImgSearch
	If ImgMethod
	{
		ImagePath = data/altimg
	}
	else
	{
		ImagePath = data/img
	}
	
	WinGet, winid, ID, ahk_class %wintitle%
	EnergyTimer := Energy * 300000
	
	IfNotExist, %A_ScriptDir%/%ImagePath%/					;begin image calibration
	{
		FileCreateDir, %A_ScriptDir%/%ImagePath%
	}
	count:=0
	Loop, Files, %A_ScriptDir%\%ImagePath%\*.png, R
	{
		if A_LoopFileName in step1.png,step2.png,step3.png,ic1.png,ic2.png,reward1.png
		{
			count+=1
		}
	}
	
	if count < 6
	{
		Msgbox, 4, , Error: Missing image files. (Count:%count%) `n`n Run calibration?
		IfMsgBox, no
			exitapp
		IfMsgBox, yes
		{
			Msgbox, Goto first screen of Earth Shrine and click OK.
			ProcessSteps("Calibrate")
			Msgbox, Step 1 Complete.`n`nSelect [Earth Shrine Exp] then start.`nWatch for popups on first run.
		}
	}
	
	;Check Window size to config settings.
	WinGetPos,,, CurW, CurH, ahk_class %wintitle%
	if (CurW != (MiddleX*2)) || (CurH != (MiddleY*2))
	{
		MiddleX := CurW/2
		MiddleY := CurH/2
		Msgbox, 4, , Warning: Current window size does not match config settings.`nIf you experience issues please delete config and image folders and recalibrate.`n`nDo you want to save the new window size to settings?
		IfMsgBox, no
			return
		IfMsgBox, yes
		{
			IniWrite, %MiddleX%, %A_ScriptDir%/data/config/config.ini, Window, MiddleX
			IniWrite, %MiddleY%, %A_ScriptDir%/data/config/config.ini, Window, MiddleY
		}
	}
	return
}

LoadHotKeys()
{
	RegRead, AppLocal, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders, Local AppData
	file = %A_ScriptDir%\data\functions\hotkey.path
	path = %AppLocal%\nox\com.square_enix.android_googleplay.FFBEWW.import_900x1440.xml
	IfNotExist, %path%
	{
		FileCopy, %file%, path
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