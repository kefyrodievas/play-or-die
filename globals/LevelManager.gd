extends Node

var floor_variants = {
	"1_floor": [
		"res://scenes/1_1floor.tscn",
		"res://scenes/1_2floor.tscn",
		"res://scenes/1_3floor.tscn"
	],
	"2ndFloor": [
		"res://scenes/2ndFloor.tscn",
		"res://scenes/2ndFloorB.tscn",
		"res://scenes/2ndFloorC.tscn"
	],
	"3rdFloor": [
		"res://scenes/3_rd_floor.tscn",
		"res://scenes/3_rd_floorB.tscn",
		"res://scenes/3_rd_floorC.tscn"
	],
	"Main": [
		"res://scenes/main.tscn",
	],
	"Boss1": [
		"res://scenes/Boss_scene1.tscn",
	],
	"Boss2": [
		"res://scenes/Boss_scene2.tscn",
	],
	"Boss3": [
		"res://scenes/Boss_scene3.tscn",
	],
}

var last_variant = {}

func get_random_variant(floor_name: String) -> String:
	GameData.play_floor_music(floor_name)
	
	var variants = floor_variants[floor_name]
	if variants.size() == 1:
		return variants[0]
	var pick = randi() % variants.size()
	while pick == last_variant.get(floor_name, -1):
		pick = randi() % variants.size()
	last_variant[floor_name] = pick
	return variants[pick]
