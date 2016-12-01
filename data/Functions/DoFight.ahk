global repeatcount

DoFight(path)
{
	Debug3 = Fightpath: %PATH%
	if path = DAUTO
	{
		Move("LD")						;dungeon enable auto only
		return
	}
	else if path = AUTO
	{
		Move("LD")						;enable auto
		Move("LD")						;disable auto
		return
	}
	else IfNotExist, %path%
	{
		PB("Error loading combat path, file missing. (Path:%path%) Defaulting to Auto.")
		DoFight("Auto")
		return
		;Msgbox, Error loading combat path, file missing. (Path:%path%) Defaulting to Auto.
	}
	IniRead, round, %path%, Repeat, Repeat
	if (round = ERROR) || (!round)
	{
		round = Round%FightRound%
		repeatcount=fclick
	}
	else
	{
		StringSplit, repeat, round, `,
		if repeat2
		{
			if !repeatcount
			{
				repeatcount:=repeat2
				repeatcount+=1
			}
			
			if repeatcount > 1
			{
				round := repeat1
				repeatcount := repeat2 - 1
			}
			else
			{
				round = Default
				repeatcount-=1
			}
		}
		else if FightRound = 1
		{
			repeatcount=fclick
		}
		else
		{
			repeatcount=click
		}
	}
	Loop, 6
	{
		unit = Unit%A_Index%
		fAction1:=
		fAction2:=
		fAction3:=
		fAction4:=
		IniRead, fAction, %path%, %round%, %unit%
		StringSplit, fAction, fAction, `,
;		MSGBOX %FACTION1% - %FACTION2% - %FACTION3% - %FACTION4% MSGBOX %REPEATCOUNT%
		If fAction1 = ERROR
		{
			IniRead, fAction, %path%, Default, %unit%
			StringSplit, fAction, fAction, `,
			repeatcount=fclick
			;continue		;Default to auto attack
		}
		if fAction1 = A
		{
			repeatcount=fclick
			continue
		}
		else if fAction1 = C
		{
			if fAction4										;if we have a cast order
			{
				repeatcount = fclick
				CastPriority := 1
				CastPriority%fAction4% := A_Index			;CastPriority(#1-6) = Unit#
			}
			if repeatcount = fclick							;Skip spell queue if we dont have cast priority or not on first round.
			{
				CastSpell(A_Index, fAction2, fAction3)
			}
		}
;		else if fAction1 = D								;ADD THIS LATER(DEFEND)		
	}
	if CastPriority
	{
		done := 1
		While done < 7
		{
			Loop, 6
			{
				If CastPriority%A_Index% = %done%
				{
					ClickSpell(A_Index)						;Cast Spell
					done+=1
				}
			}
		}
	}
	else
	{
		if repeatcount = click
		{
			Move("M", , , .75, 1.92)			;click repeat button
		}
		else
		{
			Move("LD")						;enable auto
			Move("LD")						;disable auto
		}
	}
	return
}

CastSpell(unit, spell, target:=0)				;;;****NEEDS IMAGE DETECTION FOR DEAD, STONED, ETC
{
	Debug3 = CastSpell: %unit%, %spell%, %target%
	if FightMode
	{
		WinWaitActive ahk_class %wintitle%
;		Send, %unit%
		if unit = 1
		{
			x1 := MiddleX * .22
			y1 := MiddleY * 1.3
			x2 := MiddleX * .65
			y2 := MiddleY * 1.3
		}
		else if unit = 2
		{
			x1 := MiddleX * 1.23
			y1 := MiddleY * 1.3
			x2 := MiddleX * 1.63
			y2 := MiddleY * 1.3
		}
		else if unit = 3
		{
			x1 := MiddleX * .22
			y1 := MiddleY * 1.53
			x2 := MiddleX * .65
			y2 := MiddleY * 1.53
		}
		else if unit = 4
		{
			x1 := MiddleX * 1.23
			y1 := MiddleY * 1.53
			x2 := MiddleX * 1.63
			y2 := MiddleY * 1.53
		}
		else if unit = 5
		{
			x1 := MiddleX * .22
			y1 := MiddleY * 1.75
			x2 := MiddleX * .65
			y2 := MiddleY * 1.75
		}
		else if unit = 6
		{
			x1 := MiddleX * 1.23
			y1 := MiddleY * 1.75
			x2 := MiddleX * 1.63
			y2 := MiddleY * 1.75
		}
		SendEvent {click, %x1%, %y1%, down}{click, %x2%, %y2%, up}
	}
	else
	{
		if !ControlTarget
		{
			WinGetTitle, ControlTarget, ahk_class %wintitle%		;Send keys to title not class.
		}
		ControlSend, , %unit%, %ControlTarget%						;Press unit# 1-6
	}
	sleep, 1000
	if spell <= 6												;Spell on first page
	{
		ClickSpell(spell)
	}
	else if spell > 6
	{									
		scrolldown := (spell - 6) / 2								;scrolldown 1 row for every 2 spells
		While scrolldown > 0
		{
			if FightMode
			{
;				Send, 0
;				sleep, 500
				y1 := MiddleY * 1.8
				if scrolldown >= 2.5
				{
					y2 := MiddleY * 1.2
					moved := 3
				}
				else if scrolldown >= 1.5
				{
					y2 := MiddleY * 1.41
					moved := 2
				}
				else
				{
					y2 := MiddleY * 1.6
					moved := 1
				}
				SendEvent {click, %MiddleX%, %y1%, down}{click, %MiddleX%, %y2%, up}
				
			}
			else
			{
				ControlSend, , 0, %ControlTarget%
				moved := 1
			}
			Sleep,  1500
			spell-=(moved*2)										;spell moved up 2 slots
			scrolldown-=moved 
		}
		ClickSpell(spell)
	}
	if target
	{
		sleep, 500
		ClickSpell(target)
		target=
	}
	return
}

ClickSpell(num)
{
	if num = 1
	{
		Move("M",,,.45,1.3)
	}
	else if num = 2
	{
		Move("M",,,1.45,1.3)
	}
	if num = 3
	{
		Move("M",,,.45,1.5)
	}
	else if num = 4
	{
		Move("M",,,1.45,1.5)
	}
	if num = 5
	{
		Move("M",,,.45,1.72)
	}
	else if num = 6
	{
		Move("M",,, 1.45, 1.72)
	}
	else if num = 7									;target boss for raise
	{
		Move("M", , 1500, .5, 1.91)						;Click 'select target'
		Move("M", , 1500, .5, .75)						;Click on boss
	}
	return
}