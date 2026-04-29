extends CanvasLayer

# Use @onready to find the Samurai by name in the scene tree
@onready var samurai = get_tree().root.find_child("Samurai", true, false)

@onready var hud = $HUD
@onready var pause_menu = $PauseMenu
@onready var shop = $Shop
@onready var start_menu = $StartMenu
@onready var gamble = $DeathGambleMenu
@onready var gambler_menu = $Gamble

@onready var score_label = $HUD/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/NinePatchRect/HBoxContainer/ScoreNum
@onready var highscore_label = $HUD/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/NinePatchRect/HBoxContainer2/HighscoreNum
@onready var health_bar = $HUD/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/NinePatchRect/HealthBar

#SHOP
@onready var luck_bar = $Shop/LuckBar
@onready var luck_cost_label = $Shop/LuckCost
@onready var luck_button = $Shop/Luck

@onready var health_bar_shop = $Shop/HealthBar
@onready var health_cost_label = $Shop/HealthCost
@onready var health_button = $Shop/Health

@onready var speed_bar = $Shop/SpeedBar
@onready var speed_cost_label = $Shop/SpeedCost
@onready var speed_button = $Shop/Speed

@onready var defense_bar = $Shop/DefenseBar
@onready var defense_cost_label = $Shop/DefenseCost
@onready var defense_button = $Shop/Defense

@onready var strenght_bar = $Shop/StrenghtBar
@onready var strenght_cost_label = $Shop/StrenghtCost
@onready var strenght_button = $Shop/Strenght

@onready var jump_height_bar = $Shop/JumpHeightBar
@onready var jump_height_cost_label = $Shop/Jump_HeightCost
@onready var jump_height_button = $Shop/Jump_Height

var cd_timer = preload("res://scenes/cd_timer.tscn")


var luck_data = {
	"bar": null,
	"label": null,
	"button": null,
	"textures": [
		preload("res://assets/img/Shop bars/luck/01.png"),
		preload("res://assets/img/Shop bars/luck/02.png"),
		preload("res://assets/img/Shop bars/luck/03.png"),
		preload("res://assets/img/Shop bars/luck/04.png"),
		preload("res://assets/img/Shop bars/luck/05.png")
	],
	"costs": [ 200, 300, 500, 1000],
	"level": 0
}

var health_data = {
	"bar": null,
	"label": null,
	"button": null,
	"textures": [
		preload("res://assets/img/Shop bars/health/01.png"),
		preload("res://assets/img/Shop bars/health/02.png"),
		preload("res://assets/img/Shop bars/health/03.png"),
		preload("res://assets/img/Shop bars/health/04.png"),
		preload("res://assets/img/Shop bars/health/05.png")
	],
	"costs": [200, 300, 500, 1000],
	"level": 0
}

var speed_data = {
	"bar": null,
	"label": null,
	"button": null,
	"textures": [
		preload("res://assets/img/Shop bars/speed/01.png"),
		preload("res://assets/img/Shop bars/speed/02.png"),
		preload("res://assets/img/Shop bars/speed/03.png"),
		preload("res://assets/img/Shop bars/speed/04.png"),
		preload("res://assets/img/Shop bars/speed/05.png")
	],
	"costs": [200, 300, 500, 1000],
	"level": 0
}

var defense_data = {
	"bar": null,
	"label": null,
	"button": null,
	"textures": [
		preload("res://assets/img/Shop bars/defense/01.png"),
		preload("res://assets/img/Shop bars/defense/02.png"),
		preload("res://assets/img/Shop bars/defense/03.png"),
		preload("res://assets/img/Shop bars/defense/04.png"),
		preload("res://assets/img/Shop bars/defense/05.png")
	],
	"costs": [250, 400, 1000, 2000],
	"level": 0
}

var strenght_data = {
	"bar": null,
	"label": null,
	"button": null,
	"textures": [
		preload("res://assets/img/Shop bars/strenght/01.png"),
		preload("res://assets/img/Shop bars/strenght/02.png"),
		preload("res://assets/img/Shop bars/strenght/03.png"),
		preload("res://assets/img/Shop bars/strenght/04.png"),
		preload("res://assets/img/Shop bars/strenght/05.png")
	],
	"costs": [240, 450, 900, 1500],
	"level": 0
}

var jump_height_data = {
	"bar": null,
	"label": null,
	"button": null,
	"textures": [
		preload("res://assets/img/Shop bars/Jump height/01.png"),
		preload("res://assets/img/Shop bars/Jump height/02.png"),
		preload("res://assets/img/Shop bars/Jump height/03.png"),
		preload("res://assets/img/Shop bars/Jump height/04.png"),
		preload("res://assets/img/Shop bars/Jump height/05.png")
	],
	"costs": [200, 350, 700, 1200],
	"level": 0
}

func _ready():
	# 1. Ensure the UI itself can process even when the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Initial view
	get_tree().paused = true
	start_menu.show()
	shop.hide()
	gambler_menu.hide()
	GameData.play_floor_music("menu")
	pause_menu.hide()
	#hud.hide()
	gamble.hide()
	# reikes imti is player, kai numirsta
	$DeathGambleMenu/Score.text = "Score: 0"
	# Wait until the next frame AND until the scene tree actually has the new nodes
	await get_tree().process_frame
	# Try to connect. If it fails, wait one more frame and try again.
	#_connect_samurai_signals()
	#if not samurai:
		#await get_tree().create_timer(0.1).timeout
		#_connect_samurai_signals()
	#SHOP
	luck_data["bar"] = luck_bar
	luck_data["label"] = luck_cost_label
	luck_data["button"] = luck_button

	health_data["bar"] = health_bar_shop
	health_data["label"] = health_cost_label
	health_data["button"] = health_button

	speed_data["bar"] = speed_bar
	speed_data["label"] = speed_cost_label
	speed_data["button"] = speed_button

	defense_data["bar"] = defense_bar
	defense_data["label"] = defense_cost_label
	defense_data["button"] = defense_button

	strenght_data["bar"] = strenght_bar
	strenght_data["label"] = strenght_cost_label
	strenght_data["button"] = strenght_button

	jump_height_data["bar"] = jump_height_bar
	jump_height_data["label"] = jump_height_cost_label
	jump_height_data["button"] = jump_height_button

	update_upgrade_ui(luck_data)
	update_upgrade_ui(health_data)
	update_upgrade_ui(speed_data)
	update_upgrade_ui(defense_data)
	update_upgrade_ui(strenght_data)
	update_upgrade_ui(jump_height_data)

	luck_button.pressed.connect(func(): buy_upgrade(luck_data))
	health_button.pressed.connect(func(): buy_upgrade(health_data))
	speed_button.pressed.connect(func(): buy_upgrade(speed_data))
	defense_button.pressed.connect(func(): buy_upgrade(defense_data))
	strenght_button.pressed.connect(func(): buy_upgrade(strenght_data))
	jump_height_button.pressed.connect(func(): buy_upgrade(jump_height_data))
	
	_sync_initial_data()
	

func _sync_initial_data():
	# 1. Sync the local dictionary levels with the loaded GameData
	luck_data["level"] = GameData.luck_level
	health_data["level"] = GameData.health_level
	speed_data["level"] = GameData.speed_level
	defense_data["level"] = GameData.defense_level
	strenght_data["level"] = GameData.strength_level
	jump_height_data["level"] = GameData.jump_level
	# 2. Refresh all visual bars and costs
	update_upgrade_ui(luck_data)
	update_upgrade_ui(health_data)
	update_upgrade_ui(speed_data)
	update_upgrade_ui(defense_data)
	update_upgrade_ui(strenght_data)
	update_upgrade_ui(jump_height_data)
	
	# 3. Update the money display
	$Shop/Money.text = "Score: " + str(GameData.total_bank_score)

	
# CONNECT TO SAMURAI SIGNALS
func _connect_samurai_signals():
	# Look for the Samurai everywhere in the root
	samurai = get_tree().root.find_child("Samurai", true, false)
	if samurai:
		print("Samurai found! Connecting signals...")
		# Use 'disconnect' first if you want to be extra safe, 
		# but 'is_connected' check is usually enough
		if not samurai.health_changed.is_connected(_on_samurai_health_changed):
			samurai.health_changed.connect(_on_samurai_health_changed)
		if not samurai.score_changed.is_connected(_on_samurai_score_changed):
			samurai.score_changed.connect(_on_samurai_score_changed)
		if not samurai.highscore_changed.is_connected(_on_samurai_highscore_changed):
			samurai.highscore_changed.connect(_on_samurai_highscore_changed)
		if not samurai.got_powerup.is_connected(_on_samurai_get_powerup):
			samurai.got_powerup.connect(_on_samurai_get_powerup)
		
		# Sync the UI immediately
		_set_score_val(samurai.score)
		_set_hp_val(samurai.health)
		_set_highscore_val(GameData.load_highscore())
	else:
		print("Connection Failed: Samurai not found in the current scene tree.")
# --- SIGNAL CALLBACKS (From Samurai) ---

func _on_samurai_get_powerup(timer):
	var cd = cd_timer.instantiate();
	cd.call("set_timer", timer)
	$HUD/MarginContainer/VBoxContainer/NinePatchRect/MarginContainer/VBoxContainer.add_child(cd)

func _on_samurai_health_changed(new_hp):
	_set_hp_val(new_hp)
	if new_hp <= 0: # death screen
		get_tree().paused = true
		hud.hide()
		gamble.show()
		$DeathGambleMenu/Gamble.disabled = false
		$DeathGambleMenu/Return.hide()
		$DeathGambleMenu/Score.text = "Score: " + str(samurai.score)

func _on_samurai_score_changed(new_score):
	_set_score_val(new_score)

func _on_samurai_highscore_changed(new_hs):
	_set_highscore_val(new_hs)

# --- VISUAL UPDATES ---
# Ensure these node paths ($HUD/...) match your scene structure exactly!
func _set_score_val(val):
	print("Updating UI score to: ", val) # Check if this prints in the console
	if score_label:
		score_label.text = str(val)
	else:
		print("CRITICAL: ScoreLabel is NULL!")

func _set_highscore_val(val):
	if highscore_label:
		highscore_label.text = str(val)

func _set_hp_val(val):
	if health_bar:
		health_bar.value = val


# --- START MENU BUTTONS ---

func _on_start_pressed():
	get_tree().paused = false
	start_menu.hide()
	hud.show()
	GameData.play_floor_music("main")
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
	

func _on_shop_open_pressed():
	start_menu.hide()
	$Shop/Money.text="Score: "+ str(GameData.total_bank_score);
	shop.show()
	GameData.play_floor_music("shop")

func _on_shop_exit_pressed():
	shop.hide()
	start_menu.show()
	GameData.play_floor_music("menu")
	
func _on_exit_pressed():
	get_tree().quit()

# --- PAUSE MENU BUTTONS ---

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		print("THE KEY IS PHYSICALLY DOWN!")
		toggle_pause()
		
func toggle_pause():
	# If we are in the start menu, don't allow pausing
	if start_menu.visible:
		return
		
	get_tree().paused = !get_tree().paused
	pause_menu.visible = get_tree().paused
	
	print("Pause State is now: ", get_tree().paused)
	
func _on_resume_btn_pressed() -> void:
	# This is what happens when you click "Resume"
	toggle_pause()

func _on_quit_btn_pressed() -> void:
	get_tree().quit()
	

# --- DEATH/GAMBLE MENU BUTTONS ---


func _on_gamble_pressed() -> void:
	# Disable the button immediately so they can't spam it
	$DeathGambleMenu/Gamble.disabled = true
	# 1. Start the animation
	$DeathGambleMenu/Dice/AnimatedSprite2D.play()
	# 2. Wait for a random amount of time (1 to 2.5 seconds)
	#var wait_time = randf_range(1.0, 2.5)
	var wait_time = 1;
	await get_tree().create_timer(wait_time).timeout
	
	# 3. Stop the animation
	$DeathGambleMenu/Dice/AnimatedSprite2D.pause()
	# 4. Roll the logic (1 to 6)
	var roll = randi_range(1, 6)
	_process_gamble_result(roll)
	
	# Show return button ONLY if they didn't resurrect
	if roll != 1:
		$DeathGambleMenu/Return.show()
	
func _process_gamble_result(roll: int):
	var msg_label = $DeathGambleMenu/Score # We use this to show the result text
	
	match roll:
		1: # CONTINUE GAME
			msg_label.text = "RESULT: RESURRECTION!"
			if samurai:
				samurai.health = 100 + (GameData.health_level * 20)
				samurai.is_Alive = true
				samurai.health_changed.emit(100)
			get_tree().paused = false
			gamble.hide()
			hud.show()
			return # Exit function early so gamble menu disappears
			
		2: # LOSE ALL SCORE
			msg_label.text = "RESULT: LOST ALL SCORE"
			GameData.current_score = 0
			_set_score_val(0)
			
		3: # LOSE 1 LEVEL OF ONE RANDOM POWERUP
			var key = GameData.upgrade_keys.pick_random()
			_modify_upgrade_level(key, -1)
			msg_label.text = "RESULT: LOST 1 LEVEL OF " + key.to_upper()
			
		4: # LOSE 1 LEVEL OF EVERY POWERUP
			msg_label.text = "RESULT: ALL POWERUPS -1 LEVEL"
			for key in GameData.upgrade_keys:
				_modify_upgrade_level(key, -1)
				
		5: # LOSE ALL LEVELS OF ALL POWERUPS
			msg_label.text = "RESULT: ALL POWERUPS RESET TO 0"
			for key in GameData.upgrade_keys:
				_modify_upgrade_level(key, -99) # Forces it to 0
				
		6: # GAIN 1 LEVEL FOR ONE RANDOM POWERUP
			var key = GameData.upgrade_keys.pick_random()
			_modify_upgrade_level(key, 1)
			msg_label.text = "RESULT: POWERUP +1 LEVEL " + key.to_upper()

	# After changing levels, update the Shop visual bars
	_sync_shop_with_gamedata()
	
# Helper function to safely change levels in GameData
func _modify_upgrade_level(upgrade_name: String, amount: int):
	var current = GameData.get(upgrade_name + "_level")
	var new_val = clamp(current + amount, 0, 4) # Max level is 4 (5 textures)
	GameData.set(upgrade_name + "_level", new_val)

# Helper to make sure the Shop bars match the new levels
func _sync_shop_with_gamedata():
	luck_data["level"] = GameData.luck_level
	health_data["level"] = GameData.health_level
	speed_data["level"] = GameData.speed_level
	defense_data["level"] = GameData.defense_level
	strenght_data["level"] = GameData.strength_level
	jump_height_data["level"] = GameData.jump_level
	
	update_upgrade_ui(luck_data)
	update_upgrade_ui(health_data)
	update_upgrade_ui(speed_data)
	update_upgrade_ui(defense_data)
	update_upgrade_ui(strenght_data)
	update_upgrade_ui(jump_height_data)
	
func update_upgrade_ui(data: Dictionary) -> void:
	data["bar"].texture = data["textures"][data["level"]]

	if data["level"] >= data["textures"].size() - 1:
		data["label"].text = " MAX"
		data["button"].disabled = true
	else:
		data["label"].text = str(' ',data["costs"][data["level"]])
		data["button"].disabled = false

func buy_upgrade(data: Dictionary) -> void:
	if data["level"] >= data["textures"].size() - 1:
		return

	var cost = data["costs"][data["level"]]

	if GameData.total_bank_score < cost: #Player's Money = 10000
		print("Not enough score")
		return
	# Subtract cost
	GameData.total_bank_score -= cost
	# Update the Shop Money Label immediately
	$Shop/Money.text = "Score: " + str(GameData.total_bank_score)
	# Increase level locally
	data["level"] += 1
	
	# SAVE the level to GameData immediately
	if data == luck_data: GameData.luck_level = data["level"]
	elif data == health_data: GameData.health_level = data["level"]
	elif data == speed_data: GameData.speed_level = data["level"]
	elif data == defense_data: GameData.defense_level = data["level"]
	elif data == strenght_data: GameData.strength_level = data["level"]
	elif data == jump_height_data: GameData.jump_level = data["level"]
	
	update_upgrade_ui(data)
	GameData.save_game_data()
	#_set_score_val(samurai.score)
	# _set_score_val(GameData.current_score)


func _on_return_pressed() -> void:
	# 1. Transfer run points to permanent money
	GameData.add_run_to_bank()
	
	# 2. Reset UI
	$DeathGambleMenu/Dice/AnimatedSprite2D.play()
	$DeathGambleMenu/Return.hide()
	
	# 3. Go to Start Menu
	gamble.hide()
	start_menu.show()
	
# Traveling Gambler opening and closing gambling screen
#Gamble node start
func open_gambler_menu():
	get_tree().paused = true
	hud.hide()
	pause_menu.hide()
	gambler_menu.show()
func close_gambler_menu():
	gambler_menu.hide()
	hud.show()
	get_tree().paused = false
func _on_return_game_pressed() -> void:
	close_gambler_menu()
#Gamble node end
