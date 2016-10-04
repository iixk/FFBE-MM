;img1 = %A_ScriptDir%/data/img/combat/ic1.png

CheckCombat()
{
	img1 := CheckScreen("combat", "ic1")
	img2 := CheckScreen("combat", "ic2")
	img3 := CheckScreen("combat", "inexp")
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
		reward2 := CheckScreen("fight", "reward3", 1)
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

CheckScreen(path, simg:=0, cal:=0)
{
	if simg
	{
		img = %A_ScriptDir%/data/img/%path%/%simg%.png
		if cal
		{
			IfNotExist, %img%
			{
				iniread Msg,%A_ScriptDir%/data/Functions/calibrate.ini,%simg%,Msg
				iniread POS,%A_ScriptDir%/data/Functions/calibrate.ini,%simg%,POS
				msgbox, %Msg%
				StringSplit, POS, POS, `,
				TakeImg(path, simg, POS1, POS2, POS3, POS4)
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
;	SetFormat, float, 0.2
	sx:=x/300
	sy:=y/495
	sw:=w/300
	sh:=h/495
	SetFormat, float, 0
;	msgbox, % sx sy sw sh
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
	}
	else
	{
		WinGet, hwnd, ID, ahk_class %wintitle%
		bmp1:=Gdip_BitmapFromHWND(hwnd)
	}
	
;	Gdip_GetDimensions(pBitmap, w, h)

	bmp2:=Gdip_CropImage(bmp1, x, y, w, h)
	
	save=%a_scriptdir%/data/img/%path%/%file%.png
	IfNotExist, %A_ScriptDir%/data/img/%path%/
	{
		FileCreateDir, %A_ScriptDir%/data/img/%path%
	}
;	msgbox %save% `n `n %x% - %y% - %w% - %h%
	
	if DebugOn
	{	
		IfNotExist, %A_ScriptDir%/data/img/debug/
		{
			FileCreateDir, %A_ScriptDir%/data/img/debug
		}
		debugsave=%a_scriptdir%/data/img/debug/source%file%.png
		Gdip_SaveBitmapToFile(bmp1, debugsave)
		debugsave=%a_scriptdir%/data/img/debug/%file%.png
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
;	msgbox %x% - %y% - %w% - %h%
	pBitmap2 := Gdip_CreateBitmap(w, h), G2 := Gdip_GraphicsFromImage(pBitmap2)
	Gdip_DrawImage(G2, pBitmap, 0, 0, w, h, x, y, w, h)
	Gdip_DeleteGraphics(G2)
	return pBitmap2
}