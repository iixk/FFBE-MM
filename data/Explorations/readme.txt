.path file syntax

##########################
Movement/Clicking menus
##########################

Each line will send one command to the script, use a comma between options.
Syntax:
Direction, Repeat#, Delay(ms), SpecialX, SpecialY

Direction:
U 		-Up
D		-Down
L		-Left
R		-Right
UL		-Up & Left
UR		-Up & Right
DL		-Down & Left
DR		-Down & Right
M		-Middle

Repeat#:
U,3		-Move Up 3 Times
L,6		-Move Left 6 Times

Delay:
D,3,5000	-Move Down 3 Times and wait 5 seconds between clicks

SpecialX:
Used when you cant get around with just a direction.
To create these values divide the xposition you want to click on by your MiddleX setting in config.ini
M,2,,.5		-Move half way up the screen twice
M,2,,1.5	-Move half way down the screen twice

SpecialY:
See SpecialX. Created by wanted Y position divided by MiddleY from config.ini
M,2,500,,.5	-Move left half way 2 times with a .5 second delay between
M,5,5000,.75,.75	-SpecialX & Y used, Move 3/4 of the way up and left at the same time.

##########################
Clearing Zones
##########################
Syntax:
ClearZone, Zone#, Method, Length

ClearZone	-Calls ClearZone

Zone#		-Zone #1 or 2

Method:		-Method of clearing
LR		-Move Left to Right
UD		-Move Up to Down
URDL		-Up Right to Down Left (old style)
DRUL		-Down Right to Up Left

Length		-Time in seconds needed to clear all mobs in the zone.

##########################
Fighting Bosses
##########################
Syntax:
FightBoss	-no options as of now