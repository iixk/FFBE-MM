;OnExit, EXIT_LABEL
;img1 = %A_ScriptDir%/data/img/combat/ic1.png

CheckCombat()
{
;	img1 = %A_ScriptDir%/data/img/combat/ic1.png
;	img2 = %A_ScriptDir%/data/img/combat/ic2.png
;	img3 = %A_ScriptDir%/data/img/screen/inexp.png
;	img4 = %A_ScriptDir%/data/img/fight/reward1.png
	img1 := CheckScreen("combat", "ic1")
	img2 := CheckScreen("combat", "ic2")
	img3 := CheckScreen("combat", "inexp")
;	img1 := CheckScreen("reward", "reward1")
	if (img1)
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
		reward1 := CheckScreen("fight", "reward1")
		reward2 := CheckScreen("fight", "reward3")
		if (reward1) || (reward2)
		{
			inCombat := 0
			return
		}
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

CheckScreen(path, simg:=0)
{
	if simg
	{
		img = %A_ScriptDir%/data/img/%path%/%simg%.png
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
		Loop, Files, %A_ScriptDir%/data/img/%path%/*.png
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
				img = %A_ScriptDir%/data/img/%path%/%img2%
				;msgbox %A_ScriptDir%/data/img/%path%/%img%
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
		MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
		ExitApp
	}

	pToken := Gdip_Startup()
	WinGetPos, x, y, w, h, ahk_class %wintitle%
	loc= %x%|%y%|%w%|%h%
	
	bmpHaystack:=Gdip_BitmapFromScreen(loc)
	;bmpHaystack := Gdip_BitmapFromHWND(winid)
	bmpNeedle := Gdip_CreateBitmapFromFile(img)
	RET := Gdip_ImageSearch(bmpHaystack,bmpNeedle,LIST,0,0,0,0,0,0xFFFFFF,1,0)
	
	file=%a_scriptdir%\test.png
	Gdip_SaveBitmapToFile(bmpHaystack, file)
	
	Gdip_DisposeImage(bmpHaystack)
	Gdip_DisposeImage(bmpNeedle)
	DeleteObject(bmpHaystack)
	DeleteObject(bmpNeedle)
	Gdip_Shutdown(pToken)
	
	;MsgBox, % img "`n`nReturned: " RET "`n`n" LIST
	WinSet,Redraw,, Ahk_id %winid%
	if RET>0
	{
		return %RET%
	}
	else
	{
		return
	}
}

;EXIT_LABEL: ; be really sure the script will shutdown GDIP
;Gdip_Shutdown(gdipToken)
;EXITAPP
;return