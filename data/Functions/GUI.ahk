Global GPath
Global GilSearch
Global GFPath
LoadGUI()
{
	if !LoadedExp
	{
		Loop, Files, %A_ScriptDir%/data/Explorations/*.ini
		{
			IniRead, Name, %A_ScriptDir%/data/Explorations/%A_LoopFileName%, Exploration, Title
			IniWrite, %A_LoopFileName%, %A_ScriptDir%/data/config/config.ini, ExpList, %Name%
			if !LoadedExp
			{
				LoadedExp = %Name%
			}
			else
			{
				LoadedExp = %LoadedExp%|%Name%
			}
		}
		Loop, Files, %A_ScriptDir%/data/FightPaths/*.ini
		{
			if !FPList
			{
				FPList = AUTO|%A_LoopFileName%
			}
			else
			{
				FPList = %FPList%|%A_LoopFileName%
			}
		}
	}
	
	StringReplace, List, LoadedExp, %Exploration%, %Exploration%|
	iniread FightPath, %A_ScriptDir%/data/Explorations/%ExpFile%, Path, FightPath
	if (FightPath = ERROR) || (!FightPath)
	{
		StringReplace, FPList2, FPList, AUTO, AUTO|
	}
	else
	{
		StringReplace, FPList2, FPList, %FightPath%, %FightPath%|
	}
	;	GilSearch := ImgFileOn
	
	Gui Main: New, -MaximizeBox
	Gui Font, s14 Bold, Ms Shell Dlg 2
	Gui Add, Text, x47 y20 w296 h23 Center, [FFBE - MM] by Trashedd
	Gui Font
	Gui Add, Text, x-1 y60 w402 h2 0x10
	Gui Add, Button, x80 y261 w110 h41 gStart, Start
	Gui Add, Button, x202 y261 w110 h41 gReset, Reset
	Gui Add, Button, x133 y223 w124 h23 gOptions, More Options
	Gui Font, s10 Bold, Ms Shell Dlg 2
	Gui Add, Text, x31 y72 w102 h23 +0x200, Current Path:
	Gui Add, Text, x47 y103 w313 h23 +0x200 Center, Options:
	Gui Add, Text, x65 y138 w125 h23 +0x200, Energy Timer:
	Gui Add, Text, x31 y171 w102 h23 +0x200, Fight Path:
;	Gui Add, CheckBox, x135 y180 w130 h23 vImgFileOn Checked%ImgFileOn%, Gil Image Search
	Gui Font
	Gui Add, DropDownList, x142 y72 w208 vGPath gLoadPath, %List%|
	Gui Add, DropDownList, x142 y171 w208 vGFPath gLoadFP, %FPList2%|
	Gui Add, Edit, x207 y138 w120 h21 Center Number vEnergy, %Energy%
	Gui Add, Link, x160 y311 w71 h23, <a href="https://www.paypal.com/xclick/business=xkramx`%40gmail.com&item_name=FFBE MM - Lapis Donation&no_note=1&tax=0&currency_code=USD">Donate Lapis</a>
	Gui Show, x300 y300 w391 h333, [FFBE - MM] by Trashedd
	;h314
	

	
	;;;;;;;;start options gui
	;;;;;;;;;;;;;;;;;;;;;;;;;
	
	Gui Options: New, -MaximizeBox
	Gui +LabelOptions
	Gui Font, s14 Bold, Ms Shell Dlg 2
	Gui Add, Text, x47 y20 w296 h23 Center, [FFBE - MM] by Trashedd
	Gui Font
	Gui Add, Text, x-1 y60 w398 h2 0x10
	Gui Add, Button, x74 y344 w110 h41 gSaveOpt, Save
	Gui Add, Button, x200 y344 w110 h41 gCancelOpt, Cancel
	;Gui Font, s10 Bold, Ms Shell Dlg 2
	Gui Add, Text, x39 y71 w313 h23 Center, Options:
	Gui Add, CheckBox, x39 y236 w306 h23 vDebugOn Checked%DebugOn%, Debug Mode
	Gui Add, Text, x39 y104 w146 h23, Pushbullet API:
	Gui Add, CheckBox, x39 y170 w308 h23 vImgMethod Checked%ImgMethod%, Alt. Image Search Method (Requires active window)
	Gui Add, CheckBox, x39 y137 w307 h23 vFightMode Checked%FightMode%, Alt. Fight Mode (Requires active window)
	Gui Add, CheckBox, x39 y203 w304 h23 vImgFileOn Checked%ImgFileOn%, Check Gil on clear zone
	Gui Add, CheckBox, x39 y269 w171 h23 vSpendLapis Checked%SpendLapis%, Spend lapis to refresh energy
	Gui Add, Text, x39 y302 w120 h23 +0x200, Max lapis to spend:
	Gui Font
	Gui Add, Edit, x135 y104 w190 h21 vPB_Token, %PB_Token%				;pbedit
	Gui Add, Edit, x195 y304 w130 h21 vLapis, %Lapis%				;lapis
	Return
	
	SaveOpt:
	{
		Gui, Options:Default
		Gui, Submit, NoHide
		IniWrite, %DebugOn%, %A_ScriptDir%/data/config/config.ini, Debug, Debug
		IniWrite, %ImgMethod%, %A_ScriptDir%/data/config/config.ini, ImageSearch, Method
		IniWrite, %FightMode%, %A_ScriptDir%/data/config/config.ini, FightMode, Method
		IniWrite, %ImgFileOn%, %A_ScriptDir%/data/config/config.ini, ImageSearch, GilSearch
		IniWrite, %SpendLapis%, %A_ScriptDir%/data/config/config.ini, Options, SpendLapis
		IniWrite, %PB_Token%, %A_ScriptDir%/data/config/config.ini, PushBullet, API
		IniWrite, %SpendLapis%, %A_ScriptDir%/data/config/config.ini, Options, SpendLapis
		IniWrite, %Lapis%, %A_ScriptDir%/data/config/config.ini, Options, LapisToSpend
		reload
	}
	
	CancelOpt:
	{
		Gui, Options:Default
		Gui, Options:Cancel
		return
	}
	
	LoadFP:
	{
		Gui, Main:Default
		Gui, Submit, NoHide
		if GFPath = AUTO
		{
			iniwrite % "", %A_ScriptDir%/data/Explorations/%ExpFile%, Path, FightPath
		}
		else
		{
			iniwrite %GFPath%, %A_ScriptDir%/data/Explorations/%ExpFile%, Path, FightPath
		}
		return
	}
	
	LoadPath:
	{
		Gui, Main:Default
		Gui, Submit, NoHide
		IniWrite, %GPath%, %A_ScriptDir%/data/config/config.ini, Exploration, Current
		IniRead, GNewFile, %A_ScriptDir%/data/config/config.ini, ExpList, %GPath%				;Read ini file name
		IniWrite, %GNewFile%, %A_ScriptDir%/data/config/config.ini, Exploration, File			;Write new path ini file
		Exploration = %GPath%
		IniRead, Energy, %A_ScriptDir%/data/Explorations/%GNewFile%, Exploration, Energy
		EnergyTimer := Energy * 300000
		GuiControl, ,Energy, %Energy%
		return
	}
	
	Start:
	{
		Gui, Main:Default
		Gui, Submit, NoHide
		if Energy = 0
		{
			EnergyTimer := 10000
		}
		else
		{
			EnergyTimer := Energy * 300000
		}
		if ImgMethod || FightMode
		{
			msgbox Caution: Alt image search or alt fight mode enabled.`nKeep FFBE window active and visible or script will break.
			WinActivate, ahk_class %wintitle%
		}
;		while (true)
;		{
;			if Timer("Energy")
;			{
;				Timer("Energy", EnergyTimer)
;				Sleep, 3000
;				EnterExploration()
;				CompleteDungeon()
;			}
;		}
		StartExp()
		return
	}
		
	Options:
	{
		Gui, Options:Default
		Gui Show, w391 h403, Options - [FFBE - MM] by Trashedd
		return
	}
	
	Reset:
		reload
	GuiEscape:
	GuiClose:
		ExitApp
	OptionsGuiEscape:
	OptionsGuiClose:
		return
}
