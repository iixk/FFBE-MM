Global Z1fc
Global Z2fc
Global steps
Global sc

ProcessSteps(exp)
{
	iniread Z1fc, %exp%, Exploration, Z1FightCount
	iniread Z2fc, %exp%, Exploration, Z2FightCount
	iniread steps, %exp%, Path, Steps
	sc := 1

	While sc != steps
	{
		iniread mv, %exp%, Path, Step%sc%
		StringSplit, move, mv, `,

		if move1 = ClearZone
		{
			debug = ClearZone - %move2% - %move3%
			ClearZone(move2, move3)
			sc := sc + 1
		}
		else if move1 = "FightBoss"
		{
			FightBoss()
			sc := sc + 1
		}
		else if move1 != ClearZone || move1 != FightBoss
		{
			if !move2
			{
				move2 := 1
			}
			if !move3
			{
				move3 := 1500
			}
			if !move4
			{
				move4 := 1
			}
			if !move5
			{
				move5 := 1
			}
			Move(move1, move2, move3, move4, move5)
			sc := sc + 1
		}
		else
		{
			msgbox Something went wrong processing steps.`nDebug: m1: %move1% - m2: %move2% - m3: %move3%`nRaw: [%sc%] %mv%
		}
	}
}


;Move(UDLR,repeat,delay,specialx,specialy
Move(d, r:=1, wait:=1500, sx:=1, sy:=1)
{
	debug = Move - %d% - %r% - %wait% - %sx% - %sy%
	if d = U
	{
		x = %MiddleX%
		y = %Up%
	}
	else if d = D
	{
		x = %MiddleX%
		y = %Down%
	}
	else if d = L
	{
		x = %Left%
		y = %MiddleY%
	}
	else if d = R
	{
		x = %Right%
		y = %MiddleY% 	
	}
	else if ( d = UR ) || ( d = RU )
	{
		x = %Right%
		y = %Up%
	}
	else if ( d = UL ) || ( d = LU )
	{
		x = %Left%
		y = %Up%
	}
	else if ( d = DR ) || ( d = RD )
	{
		x = %Right%
		y = %Down%
	}
	else if ( d = DL ) || ( d = LD )
	{
		x = %Left%
		y = %Down%
	}
	else if d = M
	{
		x = %MiddleX%
		y = %MiddleY%
	}
	else 
	{
		Msgbox Error moving`nDebug: D: %d% - R: %r% - W: %wait% - SX: %sx% - SY: %sy%
	}

	Loop %r%
	{
		fx := x * sx
		fy := y * sy
		debug2 = received move - %fx% - %fy% - %wintitle%
		ControlClick, x%fX% y%fy%, ahk_class %wintitle%
		sleep, %wait%
	}
}

;ClearZone(zone:=0, m:="LR")
;{
;	Timer("ZoneOneClearTime", 60000)
;	while (Timer("ZoneOneClearTime") <> true)
;	{
;		CheckCombat()
;		While inCombat = "1"
;		{
;			DoFight()
;			CheckCombat()
;		}
;		while inCombat = "2"
;		{
;			Sleep, 1000
;			CheckCombat()
;		}
;		while inCombat = "0"
;		{
;			if ( m = LR ) || ( m = RL )
;;			{
;				Move(R, 1, 1000)
;				CheckCombat()
;				Move(L, 1, 1000)
;
;			}
;			else if ( m = UD ) || ( m = DU )
;			{
;				Move(U, 1, 1000)
;				CheckCombat()
;				Move(D, 1, 1000)
;			}
;			else if ( m = URDL ) || ( m = DLUR )
;			{
;				Move(UR, 1, 1000)
;				CheckCombat()
;				Move(DL, 1, 1000)
;			}
;			else if ( m = DRUL ) || ( m = ULDR )
;			{
;				Move(DR, 1, 1000)
;				CheckCombat()
;				Move(UL, 1, 1000)
;			}
;			else
;			{
;				msgbox Error Clearing Zone`nDebug: Z: %zone% - M: %m%
;			}
;		}
;	}
;	If zone = 0
;	{
;		return
;	}
;
;	CheckFightCount(zone)
;	if (ZoneClear = "1")
;	{
;		return
;	}
;	else if (ZoneClear = "0")
;	{
;		ClearZone(zone)
;	}
;}



DoFight()
{
Move(LD) ;click auto
}

FightBoss()
{
	Move(R,2,5000,,.45)
	Move(DL)
	Sleep, 15000
	CheckCombat()
	While inCombat = "1"
	{
		Move(LD) ;click auto
		CheckCombat()
	}
	while inCombat = "2"
	{
		Sleep, 1000
		CheckCombat()
	}
	Move(R,2,6000)
	Move(R)
	CheckCombat()
	Move(R,,6000,,.45)
}
	
