extends Node2D

@onready var gambler = $TravelingGambler

func _ready():
	randomize()

	var chance = 0.3 # 30%

	if randf() <= chance:
		gambler.visible = true
		gambler.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		gambler.visible = false
		gambler.process_mode = Node.PROCESS_MODE_DISABLED
