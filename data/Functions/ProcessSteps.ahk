Global ImgFile

ProcessSteps(exp)
{
	ImgFile=
	iniread path, %exp%, Path, PathName
	x := 0
	Loop
	{
		FileReadLine, mv, %A_ScriptDir%/data/Explorations/%path%, %A_Index%
		if ErrorLevel
			break
		x := x + 1
		;if x < 72
		;	{
		;		continue
		;	}
		move1 =
		move2 =
		move3 =
		move4 = 
		move5 =
		StringSplit, move, mv, `,
		debug3 = %A_Index% - %move1% - %move2% - %move3% - %move4% - %move5%
		if move1 = ClearZone
		{
			debug = ClearZone - %move2% - %move3%
			ClearZone(move2, move3, move4)
			continue
		}
		else if move1 = FightBoss
		{
			FightBoss()
			continue
		}
		else if move1 = Dungeon
		{
			debug = Dungeon
			ClearZone(1, "Dungeon", 120)
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
			continue
		}
		else
		{
			msgbox Something went wrong processing steps.`nDebug: m1: %move1% - m2: %move2% - m3: %move3%`nRaw: %mv%
			break
		}
	}
}


;Move(UDLR,repeat,delay,specialx,specialy
Move(d, r:=1, wait:=2000, sx:=1, sy:=1)
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
	else if ( d = "UR" ) || ( d = "RU" )
	{
		x = %Right%
		y = %Up%
	}
	else if ( d = "UL" ) || ( d = "LU" )
	{
		x = %Left%
		y = %Up%
	}
	else if ( d = "DR" ) || ( d = "RD" )
	{
		x = %Right%
		y = %MiddleY%
		sy = 1.78
	}
	else if ( d = "DL" ) || ( d = "LD" )
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
		return
	}

	Loop %r%
	{
		fx := x * sx
		fy := y * sy
		debug2 = received move - %fx% - %fy% - %wintitle%
		ControlClick, x%fX% y%fy%, ahk_class %wintitle%
		sleep, %wait%
	}
	return
}