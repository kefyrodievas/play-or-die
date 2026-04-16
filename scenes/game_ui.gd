extends CanvasLayer

# Use @onready to find the Samurai by name in the scene tree
@onready var samurai = get_tree().root.find_child("Samurai", true, false)

@onready var hud = $HUD
@onready var pause_menu = $PauseMenu
@onready var shop = $Shop
@onready var start_menu = $StartMenu
@onready var gamble = $DeathGambleMenu


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
		
		# Sync the UI immediately
		_set_score_val(samurai.score)
		_set_hp_val(samurai.health)
		_set_highscore_val(GameData.load_highscore())
	else:
		print("Connection Failed: Samurai not found in the current scene tree.")
# --- SIGNAL CALLBACKS (From Samurai) ---

func _on_samurai_health_changed(new_hp):
	_set_hp_val(new_hp)
	if new_hp <= 0: # death screen
		get_tree().paused = true
		hud.hide()
		gamble.show()
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
	# 1. Pick a random number between 0 and 2
	var wait_time = randi_range(0, 2)
	print("Waiting for ", wait_time, " seconds...")
	
	# 2. Wait for that amount of time
	await get_tree().create_timer(wait_time).timeout
	
	# 3. Stop the AnimatedSprite
	$DeathGambleMenu/Dice/AnimatedSprite2D.pause()
	print("Sprite stopped!")
	$DeathGambleMenu/Return.show()
	
	
	
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

	if 10000 < cost: #Player's Money = 10000
		print("Not enough score")
		return

	data["level"] += 1
	update_upgrade_ui(data)
	#_set_score_val(samurai.score)


func _on_return_pressed() -> void:
	GameData.current_score = 0;	
	$DeathGambleMenu/Dice/AnimatedSprite2D.play()
	$DeathGambleMenu/Return.hide()
	get_tree().paused = true
	start_menu.show()
	shop.hide()
	pause_menu.hide()
	#hud.hide()
	gamble.hide()
	pass # Replace with function body.
