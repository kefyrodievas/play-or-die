# Play Or Die

# 

# Welcome to the platformer project, built using Godot 4. This is a fast-paced action game where players control a powerful Samurai, battle fierce enemies and bosses, collect points, purchase semi-permanent upgrades, and attempt to survive through as many floors as possible!

# 

# \---

# 

# \## Core Game Features

# 

# \* \*Dynamic Scoring System: Defeat enemies, collect gems, effects, open chests to increase your score. The scoring is scaling-based: the higher the floor you reach, the more points enemies will yield upon death!

# 

# \* \*In-Game Upgrades (Shop System):\* Spend your hard-earned score in the Shop in the Main Menu to upgrade stats:

# &#x20; \* Health – Increases your maximum HP limit (+20 HP per level).

# &#x20; \* Luck – Boosts enemy item drop rates, improves your odds in the gamble menu.

# &#x20; \* Speed - Increases your speed (+40 per level).

# &#x20; \* Defense - Increases your defence (-1 HP of damage done by an enemy per level).

# &#x20; \* Strength - Increases your attack damage (+2 points of damage to deal per level).

# &#x20; \* Jump Height - Increases your jump height (+20 per level).

# 

# \* \*The Death Gamble: Dying isn't the end! Roll the dice to test your luck on the game-over screen:

# &#x20; \* Resurrection:\* Instantly revive on the current floor with fully restored health.

# &#x20; \* Penalties/Rewards:\* Risk losing your current run score, dropping an upgrade level or even all of them, or randomly gaining a free power-up level.

# &#x20; \* Note: Your persistent luck level directly increases the probability of hitting a Resurrection outcome.

# 

# \* \*Traveling Gambler: When traveling through different floors there's a chance to meet the Traveling Gambler, but be cautious as he does not attack you but still can get you killed! Upon interacting you enter a Blackjack game. The Traveling Gambler does not let you go until you win at least one game. Those who don’t win, they end up dying. 

# &#x20; \* Note: If you win you can play again for a score of 50. If you end up winning you get your 50 back and an additional 50 to your score.

# &#x20; \* Simple tutorial on how to play Blackjack: The point of the game is for the sum of your cards to be as close as possible to 21. There's two choices: stand or hit. If you choose to hit, you get an additional card from the pile and if you choose to stand, you keep your current hand. If you end up going over 21 you “bust” (lose). You play against the dealer and if the dealer gets a higher score but does not “bust” they win but if they “bust” or get a smaller score, then you win. There’s also a chance for you and the dealer to draw if you get the same score.

# 

# 

# \* \*Active Buff Display (Timers): Pick up temporary power-ups(Speed, Damage, or Jump Boosts. Active buffs and their exact expiration times are displayed cleanly on the HUD in real-time.

# &#x20; \* Note: Slain enemies have a chance to drop these power-ups.

# &#x20; \* Note: Power-ups that can be found around the game and respawn after 15 seconds.

# 

# \---

# 

# \## Technical Architecture

# 

# The project relies on a centralized data management architecture to ensure robust synchronization between gameplay mechanics and user interfaces:

# 

# \* \*GameData.gd (Global Singleton): Acts as the central data hub. It securely handles persistent player stats, saves highscores, the bank economy, and tracks the current progression state (current\_floor).

# 

# \* \*gameUi.gd (CanvasLayer): Manages all UI states (Start, Pause, Shop, and Gamble menus). It features dynamic health bar synchronization that dynamically adapts to scaling max\_value thresholds based on the player's Health upgrades.

# 

# Level manager

# 

# Traveling gambler

# 

# 

# \* \*Enemy AI: Programmed using a lightweight state machine (Roaming -> Chasing -> Attacking). Includes a continuous "tick-damage" zone and a dynamic procedural mathematical formula (remap) to scale dropped items appropriately based on the boss's physical dimensions.

# 

# \---

# 

# \## How to Download and Run the Project

# 

# Go into the releases.

# Download the binary package that works for your system.

# Double click on the downloaded package to run the game.

# 

# \---

# 

# \## Controls

# 

# A/D – Move left/right.

# Spacebar – Jump/double jump (if double jump power-up is picked up).

# Left/right Arrows – Attack left/right.

# Esc – Pause game.

# E - Open chests, go through doors, interact with the Traveling Gambler.

# Shift – Dash (if dash power-up is picked up).

# 

# \---

# 

# \## Possible Features

# \*Procedural Floor Layouts: Implement random tilemap generation to make each floor layout unique.

# \*Expanded Bestiary: Add ranged and flying enemy types to scale up the late-game difficulty. 



