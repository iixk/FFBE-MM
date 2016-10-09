Global StuckCombat

CheckCombat()
{
	img1 := CheckScreen("combat", "ic1")
	img2 := CheckScreen("combat", "ic2")
	img3 := CheckScreen("combat", "inexp")
	if img1 && !img2
	{
		inCombat := 1
		return
	}
	else if (img2)
	{
		inCombat :=2
		return
	}
	if inCombat > 0
	{
		reward1 := CheckScreen("fight", "reward1")			;Dungeon Complete
		reward2 := CheckScreen("fight", "reward3", 1)		;Fight Complete
		if (reward1) || (reward2)
		{
			inCombat := 0
			return
		}
		StuckCombat+=1
		if StuckCombat > 100
		{
			PB("Stuck in combat. Checking for popups.")
			revive:=CheckScreen("popup", "revive", 1)
			levelup:=CheckScreen("popup", "levelup", 1)

			if revive
			{
				PB("Your party died. Restarting.")
				Move("M", , , .63, .91)					;Click no, don't use lapis
				Sleep, 1000
				Move("M", , , 1.4, .91)					;Click yes, give up
				RestartExp()
				return
			}
			else if levelup
			{
				Move("M", 2)							;click through popup
			}
			else
			{
				UnStuck()
			}
		}
		
	}
	return
}

UnStuck()
{
	debug3=Running unstuck.
	where:=CheckScreen("popup")
	if where = revive
	{
		PB("Your party died. Restarting.")
		Move("M", , , .63, .91)			;Click no, don't use lapis
		Sleep, 1000
		Move("M", , , 1.4, .91)			;Click yes, give up
		RestartExp()
		return
	}
	else if where = levelup
	{
		Move("M", 2)			;click through popup
		CollectRewards()
	}
	
	where:=CheckScreen("combat")
	if where = ic1
	{
		DoFight(FightPath)					;Try to finish fight
		UnStuck()
		return
	}
	else if where = ic2
	{
		Sleep, 30000						;Try to wait for fight to finish.
		UnStuck()
		return
	}
	else if where = inexp
	{
		PB("Stuck in exploration. Attempted unstuck.")
		return
	}
	
	where:=CheckScreen("fight")
	If (where = reward1) || (where = reward2) || (where = reward4)
	{
		CollectRewards()					;Try and collect rewards
	}
	else if where = reward3
	{
		Move("M")							;End of dungeon fight, click then collect rewards
		Sleep, 1000
		CollectRewards()
	}
	else if (where = step1) || (where = stepv1)
	{
		RestartExp()
	}
	else if where = step2
	{
		Move("M", , , .2, .45)			;Click back
		RestartExp()
	}
	else if where = step3
	{
		Move("M", , , .2, .45)			;Click back
		UnStuck()
	}
	return
}
CheckGil(img)
{
	Gil = %A_ScriptDir%/data/Explorations/%img%
	if (ImgSrc(Gil))
	{
		return img
	}
	else
	{
		return
	}
}

CheckScreen(path, simg:=0, cal:=0)
{
	if simg
	{
		img = %A_ScriptDir%/%ImagePath%/%path%/%simg%.png
		if cal
		{
			IfNotExist, %img%
			{
				iniread Msg,%A_ScriptDir%/data/Functions/calibrate.ini,%simg%,Msg
				iniread POS,%A_ScriptDir%/data/Functions/calibrate.ini,%simg%,POS
				Msgbox, 4, ,%Msg%`nSave Image(%path%/%simg%.png)?
;				IfMsgBox, no
;				{
;					Msgbox Missing Image File: %path%/%simg%`nScript will exit.
;					exitapp
;				}
				IfMsgBox, yes
				{
					StringSplit, POS, POS, `,
					TakeImg(path, simg, POS1, POS2, POS3, POS4)
				}
			}
		}
		if (ImgSrc(img))
		{
			return simg
		}
		else
		{
			return
		}
	}
	else
	{
		Loop, Files, %A_ScriptDir%/%ImagePath%/%path%/*.png
		{
			Screen%A_Index% = %A_LoopFileName%
		}
		Loop
		{
			if !Screen%A_Index%
			{
				return
			}
			else
			{
				img2 := Screen%A_Index%
				img = %A_ScriptDir%/%ImagePath%/%path%/%img2%
				;msgbox %A_ScriptDir%/%ImagePath%/%path%/%img%
				if (ImgSrc(img))
				{
					StringSplit, where, img2, .
					return where1
					break
				}
			}
		}
	}
}

ImgSrc(img)
{
	If !pToken := Gdip_Startup()
	{
		pToken := Gdip_Startup()
		;MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
		;ExitApp
	}
;	pToken := Gdip_Startup()						;moved up, only call once

	if ImgMethod
	{
		WinWaitActive ahk_class %wintitle%
		WinGetPos, x, y, w, h, ahk_class %wintitle%
		loc= %x%|%y%|%w%|%h%
		bmpHaystack:=Gdip_BitmapFromScreen(loc)
	}
	else
	{
		WinGet, hwnd, ID, ahk_class %wintitle%
		bmpHaystack:=Gdip_BitmapFromHWND(hwnd)
	}

	bmpNeedle := Gdip_CreateBitmapFromFile(img)
	RET := Gdip_ImageSearch(bmpHaystack,bmpNeedle,LIST,0,0,0,0,0,0xFFFFFF,1,0)
	
;	file=%a_scriptdir%\test.png
;	Gdip_SaveBitmapToFile(bmpHaystack, file)
	
	Gdip_DisposeImage(bmpHaystack)
	Gdip_DisposeImage(bmpNeedle)
	DeleteObject(bmpHaystack)
	DeleteObject(bmpNeedle)
;	Gdip_Shutdown(pToken)							;moved to main ahk
	
;	MsgBox, % img "`n`nReturned: " RET "`n`n" LIST	;test only
	if RET>0
	{
		return %RET%
	}
	else
	{
		return
	}
}

TakeImg(path, file, x, y, w, h)
{
	If !pToken := Gdip_Startup()
	{
		pToken := Gdip_Startup()
	}
	sx:=x/300
	sy:=y/495
	sw:=w/300
	sh:=h/495
	SetFormat, float, 0
	x:=MiddleX*sx
	y:=MiddleY*sy
	w:=MiddleX*sw
	h:=MiddleY*sh
	SetFormat, float, 0.2
	
	if ImgMethod
	{
		WinWaitActive ahk_class %wintitle%
		WinGetPos, ssx, ssy, ssw, ssh, ahk_class %wintitle%
		loc= %ssx%|%ssy%|%ssw%|%ssh%
		bmp1:=Gdip_BitmapFromScreen(loc)
		bmp2:=Gdip_CropImage(bmp1, x, y, w, h)
	}
	else
	{
		WinGet, hwnd, ID, ahk_class %wintitle%
		bmp1:=Gdip_BitmapFromHWND(hwnd)
		bmp2:=Gdip_CropImage(bmp1, x, y, w, h)
	}
		
;	Gdip_GetDimensions(pBitmap, w, h)

	save=%a_scriptdir%/%ImagePath%/%path%/%file%.png
	IfNotExist, %A_ScriptDir%/%ImagePath%/%path%/
	{
		FileCreateDir, %A_ScriptDir%/%ImagePath%/%path%
	}
	
	if DebugOn
	{	
		IfNotExist, %A_ScriptDir%/%ImagePath%/debug/
		{
			FileCreateDir, %A_ScriptDir%/%ImagePath%/debug
		}
		debugsave=%a_scriptdir%/%ImagePath%/debug/source%file%.png
		Gdip_SaveBitmapToFile(bmp1, debugsave)
		debugsave=%a_scriptdir%/data/%ImagePath%/%file%.png
		Gdip_SaveBitmapToFile(bmp2, debugsave)
	}
	Gdip_SaveBitmapToFile(bmp2, save)
	Gdip_DisposeImage(bmp1)
	Gdip_DisposeImage(bmp2)
	Gdip_DisposeImage(pBitmap2)
	Gdip_DisposeImage(pBitmap)
	DeleteObject(bmp1)
	DeleteObject(bmp2)
	Sleep, 1000
}

Gdip_CropImage(pBitmap, x, y, w, h)
{
	w:=w-x
	h:=h-y
	pBitmap2 := Gdip_CreateBitmap(w, h), G2 := Gdip_GraphicsFromImage(pBitmap2)
	Gdip_DrawImage(G2, pBitmap, 0, 0, w, h, x, y, w, h)
	Gdip_DeleteGraphics(G2)
	return pBitmap2
}