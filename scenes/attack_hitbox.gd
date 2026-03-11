extends Node2D

var time = 0.3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.add_to_group("Attack")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _rotate(degrees: float):
	self.rotate(deg_to_rad(degrees))
