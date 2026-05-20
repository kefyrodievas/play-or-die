extends Node2D

@onready var gambler = $TravelingGambler

func _ready():
	randomize()

	var chance = 0.3 + GameData.luck_level * 0.05 # 30% + 5% per luck level

	if randf() <= chance:
		gambler.visible = true
		gambler.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		gambler.visible = false
		gambler.process_mode = Node.PROCESS_MODE_DISABLED
