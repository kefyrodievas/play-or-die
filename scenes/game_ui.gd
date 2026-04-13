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
@onready var health_bar = $HUD/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/NinePatchRect/HealthBar

func _ready():
	# 1. Ensure the UI itself can process even when the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Initial view
	get_tree().paused = true
	start_menu.show()
	shop.hide()
	pause_menu.hide()
	#hud.hide()
	gamble.hide()
	# reikes imti is player, kai numirsta
	$DeathGambleMenu/Score.text = "Score: 0"
	# Wait until the next frame AND until the scene tree actually has the new nodes
	await get_tree().process_frame
	# Try to connect. If it fails, wait one more frame and try again.
	_connect_samurai_signals()
	if not samurai:
		await get_tree().create_timer(0.1).timeout
		_connect_samurai_signals()
	
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
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
	

func _on_shop_open_pressed():
	start_menu.hide()
	shop.show()

func _on_shop_exit_pressed():
	shop.hide()
	start_menu.show()
	
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
