Global FightCount
Global inCombat
Global LastCombat

EnterExploration()
{
	IniRead, file, %A_ScriptDir%/data/config/config.ini, Exploration, File
	IniRead, slot, %A_ScriptDir%/data/Explorations/%file%, Exploration, Slot

;;;;;Check for popups

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
	else 		;shit we got lost
	{
		if PB_Token
		{
			PB("Stuck entering exploration. (Step 1)")
		}
		IfNotExist, %A_ScriptDir%/data/img/popup/quest.png		;check for image file
		{
			Msgbox, 4, , Error: Missing image file.`n`nScript got stuck, was it a quest popup?
			IfMsgBox, yes
			{
				TakeImg("popup", "quest", 409, 676, 463, 699)		;save img of menu button
				Msgbox, Saved image file, please restart script.
			}
			else
			{
				Msgbox, Please restart script to continue.
				;Msgbox, 4, , Error: Missing image file.`n`nScript got stuck, is your inventory full?
			}
		}
	}
		
	Check:=CheckScreen("popup", "energy")		;Check for no Energy
	if Check
	{
		Move("M", , , .6, 1.1.7)				;Click no
		debug3 = No Energy Sleep 60s
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
			PB("Stuck entering exploration. (Step 2)")
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
			PB("Stuck entering exploration. (Step 3)")
		}
		msgbox Error: Lost path entering exploration. (Step 3)`n`nPlease press f12 and retry script.
	}
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
;	Move("R", , , ,.54)
	Sleep, 5000
	Move("M",,5000,1.8,.65)
	Sleep, 15000
	Move("M", 4, 4000, , 1.8)
	return
}

ClearZone(z, m, fc)
{
	IfNotExist, %A_ScriptDir%/data/img/combat/inexp.png		;check for image file
	{
		Msgbox, Error: Missing image file.`n`nEnsure you are in a exploration and press OK.
		TakeImg("combat", "inexp", 548, 933, 561, 945)		;save img of menu button
	}
	iniread ImgFile, %A_ScriptDir%/data/Explorations/%ExpFile%, Path, ImgFile
	if ImgFile = ERROR										;Check if imagefile defined
	{
		ImgFile=
	}
	else
	{
		ImgFile = %ImgFile%%z%
		IfNotExist, %A_ScriptDir%/data/img/explorations/%ImgFile%.png		;check if defined file exists
		{
			FightCount := fc * 1000
			NewImgFile = %ImgFile%			;trigger new image file
			ImgFile=
		}
	}
	
	if ImgFile
	{
										;Check gil on first round
		Move("M",,,1.83,1.9)			;click menu
		gil := CheckScreen("explorations", ImgFile)
		if gil
		{
			Move("M",,,1.83,1.9)		;click out of menu
			FightCount := 1	;end clearzone
			return
		}
		else
		{
			Move("M",,,1.83,1.9)		;click out of menu
			FightCount := 120000		;run two minutes
		}
	}
	else
	{
		FightCount := fc * 1000			;run energy timer from ini
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
	if NewImgFile
	{
		Move("M",,,1.83,1.9)		;click menu
		TakeImg("explorations", NewImgFile, 104, 796, 178, 816)		;save gil img
		Move("M",,,1.83,1.9)		;click out of menu
		NewImgFile =
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
	Move("M",2,3000,1.8,.65)		;Press Yes
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
			LastCombat =
			Fight =
			break
		}
	}
	Sleep, 5000
	Move("R",2,5000)
	Move("M",,5000,1.8,.65)		;Press Continue
}