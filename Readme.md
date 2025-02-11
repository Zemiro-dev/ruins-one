Ruins One is a top-down space shooter game. It is a simple one level game with upgrades and a boss.

# Game Design

You can find the design at [[Design]].

# Dev Plan

# Entities
Entities are physics objects that can be destroyed. The player, enemies, and destructible, are all entities.
- [ ] Create base entity script.
	- [ ] max_shield, max_health
	- [ ] Switching hitboxes (shield and not shield)
	- [ ] How do shields tween vs players tween?
	- [ ] Death Scene
# Player
- [ ] Create base player scene
- [ ] Create Player Sprite
- [ ]  Create Fire Animation (Anticipation, Action, Follow Through, Return)
- [ ] Player needs to 'bounce' off walls slightly. 

# Shield
- [ ] Create base shield scene
- [ ] Allow collision shape to be passed in.
- [ ] Create shield state machine
	- [ ] Idle 
	- [ ] Dead
	- [ ] Regenerating
	- [ ] Stunned

# Enemies
- [ ] Turret
- [ ] Spike Flower
- [ ] Fighter
- [ ] Bullet Spawner
	- [ ] Bullet
		- [ ] When front is hit sent out hit yellow hit pulse. Repeat this for boss.

# Destrucibles
- [ ] Base Destructible

# Boss
- [ ] TODO

# Projectiles
Projectiles are damage dealing areas meant to be short lived.
- [ ] Projectile Script

# Collectibles
Collectibles have a simple detection area. Once they detect the player they fly toward them in order to be consumed.
- [ ] Collectible Script
- [ ] Base Scene

# Environmentals
- [ ] Main Environmental Tile Set
- [ ] Base Door
- [ ] Key Door
- [ ] Signal Door
- [ ] Button Door
- [ ] Base Force Trap: Pulls entities into an area and signals when complete. 
- [ ] Base Upgrader
# UI
- [ ] Health Bar
- [ ] Shield Bar
- [ ] Main Menu
- [ ] Credits
- [ ] Game Over/Restart Screen