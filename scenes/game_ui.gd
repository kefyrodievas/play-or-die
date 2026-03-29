extends CanvasLayer

@onready var hud = $HUD
@onready var pause_menu = $PauseMenu
@onready var shop = $Shop
@onready var start_menu = $StartMenu

func _ready():
	# 1. Ensure the UI itself can process even when the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Initial view
	get_tree().paused = true
	start_menu.show()
	shop.hide()
	pause_menu.hide()
	hud.hide()

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
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		print("THE KEY IS PHYSICALLY DOWN!")
		toggle_pause()
		
func toggle_pause():
	get_tree().paused = !get_tree().paused
	pause_menu.visible = get_tree().paused
	print("Pause State is now: ", get_tree().paused)

# --- PAUSE MENU BUTTONS ---

func _on_resume_btn_pressed() -> void:
	# This is what happens when you click "Resume"
	toggle_pause()

func _on_quit_btn_pressed() -> void:
	get_tree().quit()
