
Ruins One is a one level top-down space exploration game. It has a single level with a vector based colorful aesthetic. It is written in Godot in Compatibility mode to run on the web.

# Controls

Ruins One uses a twin stick control scheme.

Left Stick - Controls the movement of the player character. Some momentum if maintained. The movement should have some weight.
Right Stick - Controls the facing of the player's cannon. Facing is very fast if not near instant. When the stick is pushed entirely to the facing direction and if the cannon is near the facing direction the cannon will fire repeatedly.
# Colors

Ruins One uses a palette of 10 colors. Each color is paired and each color usage should remain consistent.

![[Palette.svg|200]]

Blue - Player character and shield. 'Chests'.
Red - Player attacks and thrust. Inactive buttons
Pink - Enemies and some destructible.,
Yellow - Enemy attacks and shields. Always hurts the player. Indicates warning when used with a door.
Green - Health and active buttons.
Dark Green - Unused.
Purple - Environment. Cannot be damaged.
Dark Purple - Secondary Environment. Cannot be damaged.
White - UI and effects.
Black - Background, Outlines, Ui.

All - All colors except pink and yellow can be used as key cards.
# Player Character

![[Player.svg]]

Athena X Exploration Drone

A one tone player sprite. Symmetrical expect for the facing of the cannon. All player particles such as thrust and projectiles are monotone red that can vary in opacity.

# Player Attacks

![[Laser.svg]]

Basic Laser Attack. Fast Rate of Fire. Zero Spread. Medium Speed.


![[Laser2.svg]]

Improved Laser Attack. The 'wings' on the laser explode individually and do as much damage as the base laser. They can travel independently. 

# Player Shield

While the player does not start with a shield they gain one shortly after beginning the game. They are forced to enter the shield upgrade chamber to progress.

![[UpgradeTerminal.svg|100]]

The shield absorbs damage up to a point before breaking. If the player does not take damage for a short term it will begin to regenerate. The shield takes longer to regenerate after fully running out then it takes to begin regenerating. The shield will visually deactivate when running out of health
# Game Play Loop

The player enters and explores a small sci-fi space ruin containing enemy ships, traps, mines, a keycard, doors, upgrades, and a boss. The player flies through the small ruin using their drone to destroy enemies and evade attacks.

Space ships pew pew.

# Enemies

Ruins one contains a number of small enemies.

## Turret

![[Turret.svg]]

Tanky. Immobile. Rotates toward the player and fires slow moving hard hitting attacks.

# Missile Launcher

![[MissileLauncher.svg]]

Immobile. Fires slow moving explosives that missiles that home on the player and explode on contact. Only appears on walls.

# Fighter

![[Fighter.svg]]

Strafes around the player and fires shots. 
