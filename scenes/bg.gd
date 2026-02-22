extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var speed := 300  # pixels per second

func _process(delta):
	pass#$Parallax2D.scroll_offset.x += speed
