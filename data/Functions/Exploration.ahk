Global FightCount
Global inCombat
Global LastCombat
Global ResetExp
Global FightRound

StartExp()
{
	ResetExp:=
	while (!ResetExp)
	{
		if Timer("Energy")
		{
			Timer("Energy", EnergyTimer)
			Sleep, 3000
			EnterExploration()
			CompleteDungeon()
		}
	}
	return
}

RestartExp()
{
;	While (true)
;	{
		if !Timer("Energy")
		{
			ResetExp:=1				;if timer still going reset startexp
;			break
		}
		else
		{
			ResetExp:=1
			StartExp()				;Wait for timer and rerun
;			break
		}
;	}
	return
}

EnterExploration()
{
	IniRead, file, %A_ScriptDir%/data/config/config.ini, Exploration, File
	IniRead, slot, %A_ScriptDir%/data/Explorations/%file%, Exploration, Slot

;;;;;Check for popups
;	Check:=CheckScreen("popup", "frequest")
	Check:=CheckScreen("popup", "quest")
	if Check
	{
		Move("M", , 2000, .52, 1.39)
	}
	Check:=CheckScreen("popup", "items")
	if Check
	{
		PB("Items Full")
		msgbox Error: Items Full`n`nPlease press f12 and retry script.
	}
	Vortex:=
	IniRead, Vortex, %A_ScriptDir%/data/Explorations/%file%, Exploration, Vortex
	if Vortex							;need different img for vortex step1
	{
		Debug = Entering Vortex
		if Vortex = ERROR
		{
			IniWrite, % "", %A_ScriptDir%/data/Explorations/%file%, Exploration, Vortex
			Check:=CheckScreen("fight", "step1")
		}
		else
		{
			Check:=CheckScreen("fight", "stepv1", 1)			;Step1 Vortex image, make new if needed
		}
	}
	else
	{
		Check:=CheckScreen("fight", "step1")
	}
	if Check
	{
		ClickSlot(slot)
	}
	else 		;shit we got lost
	{
		Check:=CheckScreen("popup", "frequest", 1)
		if Check
		{
			Debug3 = Friend Request popup
			Move("M", , , .5, 1.5)							;click don't request new friend
			EnterExploration()
			return
		}
		PB("Stuck entering exploration. (Step 1)")
		IfNotExist, %A_ScriptDir%/%ImagePath%/popup/quest.png		;check for image file
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
		
	Check:=CheckScreen("popup", "energy")			;Check for no Energy
	if Check
	{
		if SpendLapis && Lapis > 0
		{
			PB("Refreshed energy.")
			Move("M", , , 1.4, 1.15)				;Click yes
			Lapis-=100
			IniWrite, %Lapis%, %A_ScriptDir%/data/config/config.ini, Options, LapisToSpend
		}
		else
		{
			Move("M", , 3000, .6, 1.17)				;Click no
			Move("M", , , 1.97, .58)				;Move back to slot1
			debug3 = No Energy Sleep 60s
			Sleep, 60000
			EnterExploration()						;repeat if full
			return
		}
	}
	
	Move("M", , 5000, 1, 1.8)	;CLICK NEXT
	
	Check:=CheckScreen("fight", "step2")
	if Check
	{
			Move("M", , 6000, 1,.77)				;Pick friend
	}
	else
	{
		PB("Stuck entering exploration. (Step 2)")
		UnStuck()
		return
;		msgbox Error: Lost path entering exploration. (step 2)`n`nPlease press f12 and retry script.
	}
	
	Check:=CheckScreen("fight", "step3")
	if ( Check = "step3" )
	{
			Move("M", , 6000, 1, 1.8)			;Depart & next
	}
	else
	{
		PB("Stuck entering exploration. (Step 3)")
		msgbox Error: Lost path entering exploration. (Step 3)`n`nPlease press f12 and retry script.
	}
	return
}

ClickSlot(slot)
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
	else if slot = 5
	{
		Move("M", , 6000, , 1.91)
	}
	else if slot = 6
	{
		Move("M", , 6000, 1.97, 1.44)
	}
	else if slot = 7
	{
		Move("M", , 6000, 1.97, 1.66)
	}
	else if slot = 8
	{
		Move("M", , 6000, 1.97, 1.97)
	}
	else
	{
		Move("M", , 6000, 1,.77)		;Default to slot 1
	}
}

CompleteDungeon()
{
	IniRead, file, %A_ScriptDir%/data/config/config.ini, Exploration, File
	do = %A_ScriptDir%/data/Explorations/%file%
	debug3 = %do%
	ProcessSteps(do)
	Sleep, 5000
	Move("M",,5000,1.8,.65)			;Click yes to leave
	CollectRewards()
	return
}

CollectRewards()
{
	step:=1
	count:=0
	While !collect
	{
		If step = 1
		{
			debug3 = Collect Rewards - Step1 (%count%)
			reward:=CheckScreen("fight", "reward1")
			if count > 10
			{
;				levelup:=CheckScreen("popup", "levelup", 1)
;				if levelup
;				{
				Move("M", 2)			;click through levelup popup

			}
			if count > 25
			{
				Debug3 = Stuck collecting rewards.
				PB("Stuck collecting rewards. Attempting unstuck.")
				UnStuck()
				return
			}
		}
		If step = 2
		{
			debug3 = Collect Rewards - Step2 (%count%)
			reward:=CheckScreen("fight", "reward2", 1)
			if count > 10
			{
				reward1:=CheckScreen("fight", "reward1")
				reward3:=CheckScreen("fight", "reward4")
				if reward1
				{
					step:=1
					reward1=
					reward3=
				}
				else if reward3
				{
					step:=3
					reward1=
					reward3=
				}
			}
		}
		If step = 3
		{
			debug3 = Collect Rewards - Step3 (%count%)
			reward:=CheckScreen("fight", "reward4", 1)
			if count > 10
			{
				reward1:=CheckScreen("fight", "reward1")
				reward3:=CheckScreen("fight", "reward4")
				if reward1
				{
					step:=1
					reward1=
					reward3=
				}
				else if reward3
				{
					step:=3
					reward1=
					reward3=
				}
			}
		}
		if step = 4
		{
			reward:=
			step:=
			collect:=1
		}
		if reward
		{
			Move("M", , 500)					;attempt to click through unit levelup
			Move("M", , 4000, , 1.8)
			step+=1
		}
		else
		{
			count+=1
			sleep, 1000
		}
;	Move("M", 4, 4000, , 1.8)
	}
	return
}
ClearDungeon()
{
	
}
ClearZone(z, m, fc)
{
	FightRound := 1
	IfNotExist, %A_ScriptDir%/%ImagePath%/combat/inexp.png		;check for image file
	{
		Msgbox, Error: Missing image file.`n`nEnsure you are in a exploration and press OK.
		TakeImg("combat", "inexp", 548, 933, 561, 945)		;save img of menu button
	}
	ImgFile=
	iniread ImgFile, %A_ScriptDir%/data/Explorations/%ExpFile%, Path, ImgFile
	if ImgFile = ERROR										;Check if imagefile defined
	{
		ImgFile=
	}
	else if ImgFile && ImgFileOn
	{
		ImgFile = %ImgFile%%z%
		IfNotExist, %A_ScriptDir%/%ImagePath%/explorations/%ImgFile%.png		;check if defined file exists
		{
			FightCount := fc * 1000
			NewImgFile = %ImgFile%			;trigger new image file
			ImgFile=
		}
	}
	
	if ImgFile && ImgFileOn
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
	
	iniread FightPath, %A_ScriptDir%/data/Explorations/%ExpFile%, Path, FightPath
	
	if ( FightPath = ERROR ) || !FightPath							;Check if imagefile defined
	{
		if m = Dungeon
		{
			FightPath = DAUTO								;set dungeon auto
		}
		else
		{
			FightPath = AUTO
		}
	}
	else
	{
		FightPath = %A_ScriptDir%/data/FightPaths/%FightPath%
		IfNotExist, %FightPath%
		{
			PB("Missing Fight Path, Defaulting to AUTO.")
			if m = Dungeon
			{
				FightPath = DAUTO								;set dungeon auto
			}
			else
			{
				FightPath = AUTO								;defualt to auto if missing fight path
			}
		}
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
				Sleep, 1000
				DoFight(FightPath)
				FightRound+=1
				;Sleep, 1000
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
		if ImgFileOn && ImgFile && LastCombat && inCombat = 0 && m != Dungeon
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

SpendEnergy()
{
	if SpendLapis
	{
		
	}
	else
	{
		Move("M", , , .6, 1.1.7)				;Click no
		debug3 = No Energy Sleep 60s
		Sleep, 60000
		EnterExploration()						;repeat if full
		return
	}
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
			DoFight("Auto")				;Need boss path
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