extends CanvasLayer

# Use @onready to find the Samurai by name in the scene tree
@onready var samurai = get_tree().root.find_child("Samurai", true, false)
@onready var gambler = get_tree().root.find_child("Traveling Gambler", true, false)

@onready var hud = $HUD
@onready var pause_menu = $PauseMenu
@onready var shop = $Shop
@onready var start_menu = $StartMenu
@onready var gamble = $DeathGambleMenu
@onready var gambler_menu = $Gamble

#blackjack variables
@onready var card_manager = $Gamble/CardManager
# For Traditional Layout (Option A):
@onready var deck = $Gamble/CardManager/Deck
@onready var player_hand = $Gamble/CardManager/PlayerHand
@onready var dealer_hand = $Gamble/CardManager/DealerHand
@onready var hit_button: Button = $Gamble/Hit
@onready var stand_button: Button = $Gamble/Stand
@onready var restart_button: Button = $Gamble/Restart
@onready var discard_pile = $Gamble/CardManager/DiscardPile

@onready var jump_timer = $HUD/MarginContainer/VBoxContainer/NinePatchRect/MarginContainer/VBoxContainer/jump_timer
@onready var dash_timer = $HUD/MarginContainer/VBoxContainer/NinePatchRect/MarginContainer/VBoxContainer/dash_timer
@onready var damage_timer = $HUD/MarginContainer/VBoxContainer/NinePatchRect/MarginContainer/VBoxContainer/damage_timer
@onready var score_timer = $HUD/MarginContainer/VBoxContainer/NinePatchRect/MarginContainer/VBoxContainer/score_timer


var interacting := true
var blackjack_game_over := false
var player_standing := false
var blackjack_deck_created := false
var player_won := false
var min_blackjack_games := 1
var max_blackjack_games := 8
var selected_blackjack_games := 1
var blackjack_games_played := 0
var blackjack_session_active := false


@onready var score_label = $HUD/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/NinePatchRect/HBoxContainer/ScoreNum
@onready var highscore_label = $HUD/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/NinePatchRect/HBoxContainer2/HighscoreNum
@onready var health_bar = $HUD/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/NinePatchRect/HealthBar

var score_for_gamble := 0
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
	pause_menu.hide()
	gamble.hide()
	
	GameData.play_floor_music("menu")
	
	# reikes imti is player, kai numirsta
	$DeathGambleMenu/Score.text = "Score: 0"
	# Wait until the next frame AND until the scene tree actually has the new nodes
	await get_tree().process_frame

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
	$StartMenu/Score.text="Score: "+ str(GameData.total_bank_score)

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
			
		if not samurai.got_jump_powerup.is_connected(_on_samurai_get_jump_powerup):
			samurai.got_jump_powerup.connect(_on_samurai_get_jump_powerup)
			
		if not samurai.got_dash_powerup.is_connected(_on_samurai_get_dash_powerup):
			samurai.got_dash_powerup.connect(_on_samurai_get_dash_powerup)
			
		if not samurai.got_damage_powerup.is_connected(_on_samurai_get_damage_powerup):
			samurai.got_damage_powerup.connect(_on_samurai_get_damage_powerup)
			
		if not samurai.got_score_powerup.is_connected(_on_samurai_get_score_powerup):
			samurai.got_score_powerup.connect(_on_samurai_get_score_powerup)
		
		# Sync the UI immediately
		var current_max_hp = 100 + (GameData.health_level * 20)
		_set_hp_val(samurai.health, current_max_hp)
		_set_score_val(samurai.score)
		#_set_hp_val(samurai.health)
		_set_highscore_val(GameData.load_highscore())
	else:
		print("Connection Failed: Samurai not found in the current scene tree.")
# --- SIGNAL CALLBACKS (From Samurai) ---

func _on_samurai_get_jump_powerup(timer):
	var cd = jump_timer;
	cd.call("set_timer", timer)
	#$HUD/MarginContainer/VBoxContainer/NinePatchRect/MarginContainer/VBoxContainer.add_child(cd)
func _on_samurai_get_score_powerup(timer):
	var cd = score_timer;
	cd.call("set_timer", timer)
func _on_samurai_get_damage_powerup(timer):
	var cd = damage_timer;
	cd.call("set_timer", timer)
func _on_samurai_get_dash_powerup(timer):
	var cd = dash_timer;
	cd.call("set_timer", timer)

func _on_samurai_health_changed(new_hp, max_hp = 100):
	
	_set_hp_val(new_hp, max_hp)
	
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

func _set_hp_val(val, max_val = 100):
	if health_bar:
		# Pirmiausia pakeičiame max_value, tik tada value!
		health_bar.max_value = max_val
		health_bar.value = val
		print("UI atnaujintas: ", val, "/", max_val) # Skirta patikrai console lange
# --- START MENU BUTTONS ---

func _on_start_pressed():
	# Svarbu: nunuliname išsaugotą HP, kad Samurai apply_upgrades nustatytų MAX HP
	get_viewport().set_input_as_handled()
	start_menu.hide()
	hud.show()

	GameData.player_health = 0
	GameData.play_floor_music("main")
	
	get_tree().paused = false
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main.tscn")

func _on_shop_open_pressed():
	interacting = true
	start_menu.hide()
	$Shop/Money.text="Score: "+ str(GameData.total_bank_score);
	shop.show()
	GameData.play_floor_music("shop")

func _on_shop_exit_pressed():
	interacting = false
	shop.hide()
	start_menu.show()
	GameData.play_floor_music("menu")
	$StartMenu/Score.text = "Score: " + str(GameData.total_bank_score)
	#_set_score_val(GameData.total_bank_score)
	
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
	if interacting:
		return
	if  !samurai.is_Alive:
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
	interacting = true
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
	#var roll = randi_range(1, 6)
	var outcomes = [1, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6] # 11% good
	
	# For each luck level adds more 1 and 6 outcomes (max 10/26 (around 38%) of good outcomes)
	for i in range(GameData.luck_level):
		outcomes.append(1) # Adds more possibilities to ressurect
		outcomes.append(6) # Adds more possibilities to gain one level
	
	# Pick one random out of the given 18 + 2 * luck
	var roll = outcomes.pick_random()
	print(outcomes)
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
				var max_hp = 100 + (GameData.health_level * 20) # Paskaičiuojame limitą
				samurai.health = max_hp
				samurai.is_Alive = true
				
				samurai.taking_damage = false # po to kai resurrectina uzluzta
				samurai.invincibility = false
				samurai.set_physics_process(true) # nes take damage isjungia
				var sprite = samurai.get_node_or_null("AnimatedSprite2D")
				if sprite:
					sprite.play("idle")
				
				_on_samurai_health_changed(samurai.health, max_hp)
				#samurai.health_changed.emit(samurai.health) # buvo 100
			get_tree().paused = false
			gamble.hide()
			hud.show()
			interacting = false
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
	$StartMenu/Score.text = "Score: " + str(GameData.total_bank_score)
	start_menu.show()
	interacting = false
	
# Traveling Gambler opening and closing gambling screen
#Gamble node start
func open_gambler_menu():
	interacting = true
	get_tree().paused = true
	hud.hide()
	pause_menu.hide()
	gambler_menu.show()

	player_won = false
	blackjack_game_over = false
	player_standing = false

	$Gamble/winner.text = "TO LEAVE WIN ONCE"
	$Gamble/count.text = ""
	$Gamble/showscore.text = ""
	$Gamble/Return_game.disabled = true
	$Gamble/Return_game.visible = true
	restart_button.visible = false
	$Gamble/price.visible = false
	
	await get_tree().create_timer(2, true, false, true).timeout

	score_for_gamble = int(score_label.text)
	setup_game()

	if not hit_button.pressed.is_connected(_on_hit_pressed):
		hit_button.pressed.connect(_on_hit_pressed)

	if not stand_button.pressed.is_connected(_on_stand_pressed):
		stand_button.pressed.connect(_on_stand_pressed)

	if not restart_button.pressed.is_connected(_on_restart_pressed):
		restart_button.pressed.connect(_on_restart_pressed)
func close_gambler_menu(kill: bool):
	interacting = false
	clear_blackjack_hands()
	destroy_blackjack_deck()
	GameData.current_score = score_for_gamble
	_set_score_val(score_for_gamble)
	samurai.score = score_for_gamble
	score_label.text = str(score_for_gamble)

	$Gamble/winner.text = ""
	$Gamble/count.text = ""
	$Gamble/showscore.text = ""
	restart_button.visible = false
	$Gamble/price.visible = false

	gambler = get_tree().root.find_child("TravelingGambler", true, false)

	gambler_menu.hide()
	hud.show()
	get_tree().paused = false
	samurai.set_physics_process(false)
	await get_tree().create_timer(1.0).timeout
	samurai.set_physics_process(true)
	if gambler and gambler.has_method("KILL") and kill:
		gambler.KILL(samurai)

func _on_return_game_pressed() -> void:
	close_gambler_menu(false)

	gambler = get_tree().root.find_child("TravelingGambler", true, false)

	if gambler and gambler.has_method("after_interaction"):
		gambler.after_interaction()
	else:
		print("Gambler not found or missing after_interaction()")
func destroy_blackjack_deck():
	player_hand.destroy_all_cards()
	dealer_hand.destroy_all_cards()
	deck.destroy_all_cards()
	discard_pile.destroy_all_cards()

	blackjack_deck_created = false
	blackjack_game_over = false
	player_standing = false
	player_won = false
func clear_blackjack_hands():
	var player_cards = player_hand.get_cards()
	if player_cards.size() > 0:
		for card in player_cards:
			card.set_meta("force_face_down", false)
			card.show_front = true
		discard_pile.move_cards(player_cards)

	var dealer_cards = dealer_hand.get_cards()
	if dealer_cards.size() > 0:
		for card in dealer_cards:
			card.set_meta("force_face_down", false)
			card.show_front = true
		discard_pile.move_cards(dealer_cards)
		
func play_again():
	blackjack_game_over = false
	player_standing = false
	hit_button.disabled = false
	stand_button.disabled = false
	clear_blackjack_hands()

func setup_game():
	score_label.text = str(score_for_gamble)

	$Gamble/Return_game.disabled = true
	$Gamble/Return_game.visible = true
	$Gamble/Score.visible = true
	$Gamble/showscore.visible = true
	$Gamble/showscore.text = str(score_for_gamble)
	$Gamble/count.text = ""

	blackjack_game_over = false
	player_standing = false

	dealer_hand.allow_card_movement = false
	player_hand.allow_card_movement = true

	hit_button.disabled = false
	stand_button.disabled = false
	hit_button.visible = true
	stand_button.visible = true
	restart_button.visible = false
	$Gamble/price.visible = false
	$Gamble/winner.text = ""

	clear_blackjack_hands()

	if not blackjack_deck_created:
		create_standard_deck()
		blackjack_deck_created = true

	if deck.get_card_count() < 10:
		$Gamble/winner.text = "The dealer ran out of cards :("
		hit_button.disabled = true
		stand_button.disabled = true
		await get_tree().create_timer(6, true, false, true).timeout
		_on_return_game_pressed()
		return

	shuffle_deck()

	deal_cards_to_hand(2, player_hand)
	deal_cards_to_hand(2, dealer_hand)

	hide_dealer_hole_card()
	print_scores(false)
	
func create_standard_deck():
	var suits = ["club", "diamond", "heart", "spade"]
	var values = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]

	for suit in suits:
		for value in values:
			var card_name = "%s_%s" % [suit, value]
			var card = card_manager.card_factory.create_card(card_name, deck)

			card.set_meta("value", value)
			card.set_meta("suit", suit)
			card.set_meta("force_face_down", false)

			deck.add_card(card)
			
func shuffle_deck():
	randomize()

	var cards = deck.get_top_cards(deck.get_card_count())
	cards.shuffle()

	for card in cards:
		deck.move_cards([card])

func hide_dealer_hole_card():
	var cards = dealer_hand.get_cards()
	if cards.size() >= 2:
		cards[1].set_meta("force_face_down", true)
		cards[1].show_front = false
		dealer_hand.update_card_ui()
		
func reveal_dealer_cards():
	var cards = dealer_hand.get_cards()

	for card in cards:
		card.set_meta("force_face_down", false)

	dealer_hand.update_card_ui()
	
func deal_cards_to_hand(count: int, player):
	for i in range(count):
		if deck.get_card_count() > 0:
			var card = deck.get_top_cards(1).front()
			player.move_cards([card])

func _on_hit_pressed() -> void:
	if blackjack_game_over or player_standing:
		return

	deal_cards_to_hand(1, player_hand)
	await get_tree().create_timer(0.3).timeout
	var player_value = get_hand_value(player_hand)
	$Gamble/count.text = str(player_value)
	#print("Player value: ", player_value)

	if player_value > 21:
		end_game("Player bust. Dealer wins.",false)
func _on_stand_pressed() -> void:
	if blackjack_game_over:
		return

	player_standing = true
	hit_button.disabled = true
	stand_button.disabled = true

	reveal_dealer_cards()
	dealer_turn()
func dealer_turn():
	while get_hand_value(dealer_hand) < 17:
		await get_tree().create_timer(0.5, true, false, true).timeout
		deal_cards_to_hand(1, dealer_hand)

	check_winner()
func check_winner():
	var player_value = get_hand_value(player_hand)
	var dealer_value = get_hand_value(dealer_hand)

	if player_value > 21:
		end_game("Player bust. Dealer wins.", false)
	elif dealer_value > 21:
		end_game("Dealer bust. Player wins.", true)
	elif player_value > dealer_value:
		end_game("Player wins.", true)
	elif dealer_value > player_value:
		end_game("Dealer wins.", false)
	else:
		end_game("Draw.", false)

func end_game(message: String, won: bool):
	blackjack_game_over = true
	player_won = player_won or won

	hit_button.disabled = true
	stand_button.disabled = true
	restart_button.visible = true
	$Gamble/price.visible = true

	reveal_dealer_cards()
	print_scores(true)
	#print(message)

	await get_tree().create_timer(0.3, true, false, true).timeout

	$Gamble/winner.text = message

	if won:
		score_for_gamble += 100
		$Gamble/showscore.text = str(score_for_gamble)

	if player_won:
		$Gamble/Return_game.disabled = false

func get_hand_value(hand) -> int:
	var cards = hand.get_cards()
	var total := 0
	var aces := 0

	for card in cards:
		var value = card.get_meta("value")

		if value == "A":
			total += 11
			aces += 1
		elif value in ["J", "Q", "K"]:
			total += 10
		else:
			total += int(value)

	while total > 21 and aces > 0:
		total -= 10
		aces -= 1

	return total


func get_visible_hand_value(hand) -> int:
	var cards = hand.get_cards()
	var total := 0
	var aces := 0

	for card in cards:
		if card.has_meta("force_face_down") and card.get_meta("force_face_down"):
			continue

		var value = card.get_meta("value")

		if value == "A":
			total += 11
			aces += 1
		elif value in ["J", "Q", "K"]:
			total += 10
		else:
			total += int(value)

	while total > 21 and aces > 0:
		total -= 10
		aces -= 1

	return total


func print_scores(show_dealer_full: bool):
	var player_value = get_hand_value(player_hand)
	$Gamble/count.text= str(player_value)
	var dealer_value: int
	if show_dealer_full:
		dealer_value = get_hand_value(dealer_hand)
	else:
		dealer_value = get_visible_hand_value(dealer_hand)

	print("Player: ", player_value)
	print("Dealer: ", dealer_value)


func _on_restart_pressed():
	var cost := 50

	if score_for_gamble < cost:
		clear_blackjack_hands()

		if player_won:
			$Gamble/winner.text = "Not enough score to play.\nLEAVE"
			await get_tree().create_timer(6, true, false, true).timeout
			_on_return_game_pressed()
		else:
			$Gamble/winner.text = "Not enough score to play and you have not won.\nPrepear to DIE!"
			await get_tree().create_timer(6, true, false, true).timeout
			close_gambler_menu(true)

		return

	score_for_gamble -= cost
	$Gamble/showscore.text = str(score_for_gamble) # pakeisk path jei tavo label kitas

	print("Restart pressed")
	setup_game()

#Gamble node end
