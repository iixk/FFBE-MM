FightPath.ini Syntax:

[Round1]
Unit1	Unit2
Unit3	Unit4
Unit5	Unit6

Script will perform fight sequence until battle is complete.

##########################
Options for units
##########################

A		-Auto Attack
D		-Defend (not added yet)
C		-Cast Spell

##########################
Cast Spell Syntax
##########################

C,6		-Cast spell slot 6
C,5,3		-Cast spell slot 5 on unit 3 (used for spells that need targets)

##########################
Repeat
##########################
[Repeat]
Round=Round#		-Repeats round1. This method is faster, after the first round script will press repeat button for all other rounds.

[Repeat]
Round=Round1,3		-Repeats round1 every 3rd round.

##########################
Defualt
##########################
[Default]		-Script will use this round if the fight continues past defined fight path or between repeats.
Unit1=
etc...