extends Node2D

const START_POS := Vector2i(118, 518)
const CAM_START_POS := Vector2i(0,0)

var speed : float
const START_SPEED : float = 0.0
const MAX_SPEED : int = 25
var screen_size : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	new_game()

func new_game():
	$Samurai.position = START_POS
	$Samurai.velocity = Vector2i(0,0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = Vector2i(0,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	speed = START_SPEED
	
	$Samurai.position += Vector2(speed, 0)
	
	# Farthest background (moves slowest)
	$Bg/Parallax2D.scroll_offset.x += speed * 0.2 * delta
	# Middle layer
	$Bg/Parallax2D2.scroll_offset.x += speed * 0.5 * delta
	# Front layer (moves fastest)
	$Bg/Parallax2D3.scroll_offset.x += speed * 1.0 * delta
	
	$Ground.position.x -= speed * delta
	$Camera2D.position += Vector2(speed,0)
	
	#update ground position
	if $Camera2D.position.x - $Ground.position.x > screen_size.x:
		$Ground.position.x += screen_size.x
	
	
	
	
