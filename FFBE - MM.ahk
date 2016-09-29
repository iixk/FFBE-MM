------
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force ; only one instance of script can run
#Persistent ; to make it run indefinitely

SetMouseDelay, 25
SendMode Input 
SetWorkingDir %A_ScriptDir% 
CoordMode, Mouse, Relative
SetControlDelay -1
SetFormat, float, 0.2
OnExit, EXIT_LABEL

Global debug
Global debug2
Global debug3

#Include %A_ScriptDir%/data/functions/LoadConfig.ahk
#Include %A_ScriptDir%/data/functions/ProcessSteps.ahk
#Include %A_ScriptDir%/data/functions/CheckCombat.ahk
#Include %A_ScriptDir%/data/functions/Exploration.ahk
#Include %A_ScriptDir%/data/functions/GDIP_all.ahk
#Include %A_ScriptDir%/data/functions/Gdip_ImageSearch.ahk
#Include %A_ScriptDir%/data/functions/PushBullet.ahk

LoadConfig()

if DebugOn
{
	settimer start1, 0
	return
}

start1:
if !GetKeyState("capslock","T")
{
	if tt
	{
	    	tooltip
	}
}
else			;if caps on
{

	CoordMode, ToolTip, Screen 
	CoordMode, Mouse, Relative
	MouseGetPos xx, yy 
;	SetFormat, float, 0.2
	sx := xx/MiddleX
	sy := yy/MiddleY
;	SetFormat, float, 0

	tt = 1
	tooltip Title: %wintitle%`nMiddleX/Y: %MiddleX%/%MiddleY%`nX/Y - sX/sY: %xx%/%yy% - %sx%/%sy%`nExploration: %Exploration%`nInCombat: %inCombat%`nDebug: %debug%`nDebug2: %debug2%`nDebug3: %debug3%`nImgMethod: %ImgMethod%`nImgFile: %ImgFile%, 0, 0

;Title: %wintitle%
;MiddleX/Y: %MiddleX%/%MiddleY%
;X/Y - sX/sY: %xx%/%yy% - %sx%/%sy%
;Exploration: %Exploration%
;InCombat: %inCombat%
;Debug: %debug%
;Debug2: %debug2%
;Debug3: %debug3%
;ImgMethod: %ImgMethod%
;ImgFile: %ImgFile%

	PrintScreen:: 
	clipboard =%xx%, %yy%
	return
}
return

if DebugOn
{
	Numpad8::Move("U")
	Numpad2::Move("D")
	Numpad4::Move("L")
	Numpad6::Move("R")
	Numpad9::Move("UR")
	Numpad7::Move("UL")
	Numpad1::Move("DL")
	Numpad3::Move("DR")

	f1::CompleteDungeon()
	f2::CheckCombat()
	f3::ClearZone(2, "LR", 900)
	f4::
	{
		test:=CheckScreen("fight", "reward1")
		msgbox %test%
	}
}

f12::
{
	If pToken := Gdip_Startup()
	{
		Gdip_Shutdown(pToken)
	}
	reload
}
F8::
{
	while (true)
	{
		if Timer("Energy")
		{
			;Set "3900000" to how long you want it to delay in milliseconds
			Timer("Energy", EnergyTimer)
			Sleep, 3000
			EnterExploration()
			CompleteDungeon()
		}

	}

}
F9::SelectExp()	

Timer(Timer_Name := "", Timer_Opt := "D")
{
    static
    global Timer, Timer_Count
    if !Timer
        Timer := {}
    if (Timer_Opt = "U" or Timer_Opt = "Unset")
        if IsObject(Timer[Timer_Name])
        {
            Timer.Remove(Timer_Name)
            Timer_Count --=
            return true
        }
        else
            return false
    if RegExMatch(Timer_Opt,"(\d+)",Timer_Match)
    {
        if !(Timer[Timer_Name,"Start"])
            Timer_Count += 1
        Timer[Timer_Name,"Start"] := A_TickCount
        Timer[Timer_Name,"Finish"] := A_TickCount + Timer_Match1
        Timer[Timer_Name,"Period"] := Timer_Match1
    }
    if RegExMatch(Timer_Opt,"(\D+)",Timer_Match)
        Timer_Opt := Timer_Match1
    else
        Timer_Opt := "D"
    if (Timer_Name = "")
    {
        for index, element in Timer
            Timer(index)
        return
    }
    if (Timer_Opt = "R" or Timer_Opt = "Reset")
    {
        Timer[Timer_Name,"Start"] := A_TickCount
        Timer[Timer_Name,"Finish"] := A_TickCount + Timer[Timer_Name,"Period"]
    }
    Timer[Timer_Name,"Now"] := A_TickCount
    Timer[Timer_Name,"Left"] := Timer[Timer_Name,"Finish"] - Timer[Timer_Name,"Now"]
    Timer[Timer_Name,"Elapse"] := Timer[Timer_Name,"Now"] - Timer[Timer_Name,"Start"]
    Timer[Timer_Name,"Done"] := true
    if (Timer[Timer_Name,"Left"] > 0)
        Timer[Timer_Name,"Done"] := false
    if (Timer_Opt = "D" or Timer_Opt = "Done")
        return Timer[Timer_Name,"Done"]
    if (Timer_Opt = "S" or Timer_Opt = "Start")
        return Timer[Timer_Name,"Start"]
    if (Timer_Opt = "F" or Timer_Opt = "Finish")
        return Timer[Timer_Name,"Finish"]
    if (Timer_Opt = "L" or Timer_Opt = "Left")
        return Timer[Timer_Name,"Left"]
    if (Timer_Opt = "N" or Timer_Opt = "Now")
        return Timer[Timer_Name,"Now"]
    if (Timer_Opt = "P" or Timer_Opt = "Period")
        return Timer[Timer_Name,"Period"]
    if (Timer_Opt = "E" or Timer_Opt = "Elapse")
        return Timer[Timer_Name,"Elapse"]
}

EXIT_LABEL: ; be really sure the script will shutdown GDIP
Gdip_Shutdown(gdipToken)
EXITAPP
return