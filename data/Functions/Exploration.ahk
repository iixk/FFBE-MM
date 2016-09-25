Global FightCount
Global inCombat
Global LastCombat

EnterExploration()
{
	IniRead, file, %A_ScriptDir%/data/config/config.ini, Exploration, File
	IniRead, slot, %A_ScriptDir%/data/Explorations/%file%, Exploration, Slot

	Check:=CheckScreen("popup", "quest")
	if Check
	{
		Move("M", , 2000, .52, 1.39)
	}
	Check:=CheckScreen("popup", "items")
	if Check
	{
		if PB_Token
		{
			PB("Items Full")
		}
		msgbox Error: Items Full`n`nPlease press f12 and retry script.
	}
	Check:=CheckScreen("fight", "step1")
	if Check
	{
		if slot = 1
		{
			Move("M", , 6000, 1,.77)
		}
		else if slot = 2
		{
			Move("M", , 6000)
		}
		else if slot = 3
		{
			Move("M", , 6000, , 1.41)
		}
		else if slot = 4
		{
			Move("M", , 6000, , 1.71)
		}
		else
		{
			Move("M", , 6000, 1,.77)		;Default to slot 1
		}
	}
	else 
	{
		if PB_Token
		{
			PB("Stuck on EntExp1")
		}
		msgbox Error: Lost path entering exploration. (step 1)`n`nPlease press f12 and retry script.
	}
		
	Check:=CheckScreen("popup", "energy")		;Check for Full Energy
	if Check
	{
		Move("M", , , .6, 1.1.7)				;Click no
		debug3 = Full Energy Sleep 60s
		Sleep, 60000
		EnterExploration()						;repeat if full
		return
	}
	
	Check:=CheckScreen("fight", "step2")
	if Check
	{
			Move("M", , 6000, 1,.77)			;Pick friend
	}
	else
	{
		if PB_Token
		{
			PB("Stuck on EntExp2")
		}
		msgbox Error: Lost path entering exploration. (step 2)`n`nPlease press f12 and retry script.
	}
	
	Check:=CheckScreen("fight", "step3")
	if ( Check = "step3" )
	{
			Move("M", , 6000, 1, 1.8)			;Depart & next
	}
	else
	{
		if PB_Token
		{
			PB("Stuck on EntExp3")
		}
		msgbox Error: Lost path entering exploration. (step 3)`n`nPlease press f12 and retry script.
	}
;	Color1 := 0x302A01
;	PixelGetColor quest, MiddleX, MiddleY
;	if quest = %Color1%
;	{
;		Move("M", , 2000, .52, 1.39)
;	}
	
;	Move("M", 3,3000,.53, 1.4)		;Cancel Quest
;	Move("M", 2,3000,.23,.46)		;Go back

;	Move("M", , 6000, 1,.77)			;Pick friend
;	Move("M", , 6000, 1, 1.8)			;Depart & next
	return
}

CompleteDungeon()
{
	IniRead, file, %A_ScriptDir%/data/config/config.ini, Exploration, File
	do = %A_ScriptDir%/data/Explorations/%file%
	debug3 = %do%
	ProcessSteps(do)
	Sleep, 5000
	CollectRewards()
	return
}

CollectRewards()
{
	Move("R", , , ,.54)
	Sleep, 15000
	Move("M", 5, 4000, , 1.8)
	return
}

ClearZone(z, m, fc)
{
	iniread ImgFile, %A_ScriptDir%/data/Explorations/%ExpFile%, Path, ImgFile%z%
	IfNotExist, %A_ScriptDir%/data/Explorations/%ImgFile%
	{
		ImgFile=						;check if imgfile exists - default to timer
	}
	if ImgFile
	{
	;Check Gil on first round
		Move("M",,,1.83,1.9)		;click menu
		gil := CheckGil(ImgFile)
		if gil
		{
			Move("M",,,1.83,1.9)		;click out of menu
			FightCount := 1	;end clearzone
			return
		}
		else
		{
			Move("M",,,1.83,1.9)		;click out of menu
			FightCount := 60000
		}
	}
	else
	{
		FightCount := fc * 1000
	}
	Timer("ZoneClearTime", FightCount)
	while (Timer("ZoneClearTime") <> true)
	{
		LastCombat =
		CheckCombat()
		While inCombat
		{
			if inCombat = 1
			{
				debug3 = incombat ok
				LastCombat := 1
				DoFight()
				Sleep, 1000
				CheckCombat()
			}
			else if inCombat = 2
			{
				debug3 = incombat ok 2
				LastCombat := 2
				Sleep, 1000
				CheckCombat()
			}
		}
		if ImgFile && LastCombat && inCombat = 0
		{
			Move("M",,2000)
			Move("M",,,1.83,1.9)		;click menu
			gil := CheckGil(ImgFile)
			if gil
			{
				Move("M",,,1.83,1.9)		;click out of menu
				Timer("ZoneClearTime", 1)	;end clearzone
				return
			}
			else
			{
				Move("M",,,1.83,1.9)		;click out of menu
				Timer("ZoneClearTime", 120000)		;run another 2 minutes
			}
			LastCombat =
		}
		if m = LR
		{
			Move("L",,1000)
			Move("R",,1000)
		}
		else if m = UD
		{
			Move("U",,1000)
			Move("D",,1000)
		}
		else if m = URDL
		{
			Move("UR",,1000)
			Move("DL",,1000)
		}
		else if m = DRUL
		{
			Move("DR",,1000)
			Move("UL",,1000)
		}
		else if m = Dungeon
		{
			if inCombat = 0
			{
				debug = dungeon complete
				break
			}
			continue
		}
	}
	return
}

DoFight()
{
Move("LD") ;click auto
return
}

FightBoss()
{
	Sleep, 5000
	Move("R",2,3000,,.45)
	;Timer("FightBoss", 120000)
	;while (Timer("FightBoss") <> true)
	;{
;		CheckCombat()
		Fight := 1
		While Fight
		{
			CheckCombat()
			if inCombat = 1
			{
				LastCombat := 1
				DoFight()
				Sleep, 1000
				CheckCombat()
			}
			else if inCombat = 2
			{
				LastCombat := 2
				Sleep, 1000
				CheckCombat()
			}
			else if LastCombat && inCombat = 0
			{
				debug3 = Boss done1
;				Timer("FightBoss", 1)
				LastCombat =
				Fight =
				break
			}
		}
;	}
	Move("R",2,5000)
	Move("R")
	Move("R",,5000,,.45)
	return
}