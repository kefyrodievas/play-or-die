extends CanvasLayer

@onready var hud = $HUD
@onready var pause_menu = $PauseMenu
@onready var shop = $Shop
@onready var start_menu = $StartMenu
@onready var gamble = $DeathGambleMenu

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
