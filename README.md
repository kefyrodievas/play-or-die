# Play Or Die

## Welcome to the platformer project, built using Godot 4.
This is a fast-paced action game where players control a powerful Samurai, battle fierce enemies and bosses, collect points, purchase semi-permanent upgrades, and attempt to survive through as many floors as possible!

---

## Core Game Features

### **Dynamic Scoring System**
Defeat enemies, collect gems, effects, open chests to increase your score.

The scoring is scaling-based: the higher the floor you reach, the more points enemies will yield upon death!

---

### **In-Game Upgrades (Shop System)**
Spend your hard-earned score in the Shop in the Main Menu to upgrade stats:

- **Health** – Increases your maximum HP limit (+20 HP per level).
- **Luck** – Boosts enemy item drop rates, improves your odds in the gamble menu.
- **Speed** – Increases your speed (+40 per level).
- **Defense** – Increases your defence (-1 HP of damage done by an enemy per level).
- **Strength** – Increases your attack damage (+2 points of damage to deal per level).
- **Jump Height** – Increases your jump height (+20 per level).

---

### **The Death Gamble**
Dying isn't the end! Roll the dice to test your luck on the game-over screen:

- **Resurrection** – Instantly revive on the current floor with fully restored health.
- **Penalties/Rewards** – Risk losing your current run score, dropping an upgrade level or even all of them, or randomly gaining a free power-up level.

> **Note:** Your persistent luck level directly increases the probability of hitting a Resurrection outcome.

---

### **Traveling Gambler**
When traveling through different floors there's a chance to meet the Traveling Gambler, but be cautious as he does not attack you but still can get you killed!

Upon interacting you enter a Blackjack game. The Traveling Gambler does not let you go until you win at least one game. Those who don’t win, they end up dying.

#### Notes
- If you win you can play again for a score of 50.
- If you end up winning you get your 50 back and an additional 50 to your score.

#### Simple tutorial on how to play Blackjack
The point of the game is for the sum of your cards to be as close as possible to 21.

There are two choices:
- **Stand** – Keep your current hand.
- **Hit** – Get an additional card from the pile.

Rules:
- If you go over 21 you “bust” (lose).
- You play against the dealer.
- If the dealer gets a higher score but does not “bust”, they win.
- If the dealer “busts” or gets a smaller score, then you win.
- There’s also a chance for you and the dealer to draw if you get the same score.

---

### **Active Buff Display (Timers)**
Pick up temporary power-ups (Speed, Damage, or Jump Boosts).

Active buffs and their exact expiration times are displayed cleanly on the HUD in real-time.

#### Notes
- Slain enemies have a chance to drop these power-ups.
- Power-ups found around the game respawn after 15 seconds.

---

## Technical Architecture

The project relies on a centralized data management architecture to ensure robust synchronization between gameplay mechanics and user interfaces.

### **GameData.gd (Global Singleton)**
Acts as the central data hub.

Handles:
- Persistent player stats
- Highscores
- Bank economy
- Current progression state (`current_floor`)

---

### **gameUi.gd (CanvasLayer)**
Manages all UI states:
- Start Menu
- Pause Menu
- Shop Menu
- Gamble Menu

Features:
- Dynamic health bar synchronization
- Adaptive `max_value` scaling based on Health upgrades

---

### **Level Manager**
Handles level progression and transitions.

---

### **Traveling Gambler**
Handles Blackjack interactions and gamble systems.

---

### **Enemy AI**
Programmed using a lightweight state machine:

```text
Roaming -> Chasing -> Attacking
```

Features:
- Continuous tick-damage zones
- Dynamic procedural mathematical formulas
- Boss drop scaling based on physical dimensions

---

## How to Download and Run the Project

1. Go into the releases.
2. Download the binary package that works for your system.
3. Double click on the downloaded package to run the game.

---

## Controls

| Key | Action |
|------|--------|
| `A / D` | Move left/right |
| `Spacebar` | Jump / Double jump (if double jump power-up is picked up) |
| `Left / Right Arrows` | Attack left/right |
| `Esc` | Pause game |
| `E` | Open chests, go through doors, interact with the Traveling Gambler |
| `Shift` | Dash (if dash power-up is picked up) |

---

## Possible Features

- **Procedural Floor Layouts**  
  Implement random tilemap generation to make each floor layout unique.

- **Expanded Bestiary**  
  Add ranged and flying enemy types to scale up the late-game difficulty.
  ---

## Creators

### Development Team
- Ignas K.
- Gabrielius M.
- Diana P.
- Kipras R.
- Deimantė V.

### Special Thanks
- We want to thank our profesors Tomas B. and Andrius P. for giving us feedback on our project.

---

## License

Butu gerai cia su licence dar parasyt kazka

