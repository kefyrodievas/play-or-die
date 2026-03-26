extends Node

var floor_variants = {
	"1_floor": [
		"res://scenes/1_1floor.tscn",
		"res://scenes/1_2floor.tscn",
	],
	"2ndFloor": [
		"res://scenes/2ndFloor.tscn",
		"res://scenes/2ndFloorB.tscn",
		"res://scenes/2ndFloorC.tscn"
	],
	"3rdFloor": [
		"res://scenes/3_rd_floor.tscn",
		"res://scenes/3_rd_floorB.tscn"
	],
	"Main": [
		"res://scenes/main.tscn",
	]
}

var last_variant = {}

func get_random_variant(floor_name: String) -> String:
	var variants = floor_variants[floor_name]
	if variants.size() == 1:
		return variants[0]
	var pick = randi() % variants.size()
	while pick == last_variant.get(floor_name, -1):
		pick = randi() % variants.size()
	last_variant[floor_name] = pick
	return variants[pick]
