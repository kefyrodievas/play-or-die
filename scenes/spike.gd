extends Area2D

@export var damage := 10
@export var tick_time := 1

@export var clean_behind: Texture2D
@export var clean_top: Texture2D

@export var bloody_behind: Texture2D
@export var bloody_top: Texture2D

@onready var behind_sprite: Sprite2D = $Sprite2D
@onready var top_sprite: Sprite2D = $Sprite2D2

var is_bloody := false
var bodies_inside: Array = []

func _ready():
	behind_sprite.texture = clean_behind
	top_sprite.texture = clean_top


	var timer = Timer.new()
	timer.wait_time = tick_time
	timer.autostart = true
	timer.timeout.connect(_on_tick)
	add_child(timer)


func _on_body_entered(body):
	if body.name == "Samurai":
		if body not in bodies_inside:
			bodies_inside.append(body)
		if body.has_method("take_damage"):
			body.take_damage(damage)
		if not is_bloody:
			behind_sprite.texture = bloody_behind
			top_sprite.texture = bloody_top
			is_bloody = true
			


func _on_body_exited(body):
	bodies_inside.erase(body)


func _on_tick():
	for body in bodies_inside:
		if body.has_method("take_damage"):
			body.take_damage(damage)
