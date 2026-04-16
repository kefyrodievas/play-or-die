extends Control



func _ready():
	GameData.play_floor_music("menu")

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_shop_pressed():
	get_tree().change_scene_to_file("res://scenes/shop.tscn")

func _on_exit_pressed():
	get_tree().quit()
