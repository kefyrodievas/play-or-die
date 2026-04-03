extends Node2D

const START_POS := Vector2(118, 518)
const CAM_START_POS := Vector2(0,0)

var speed : float
const START_SPEED : float = 0.0
const MAX_SPEED : int = 25
var screen_size : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	new_game()
	GameData.start_music()
	

func new_game():
	$Samurai.position = START_POS
	$Samurai.velocity = Vector2(0,0)
	#$Ground.position = Vector2(0,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	speed = START_SPEED
		
	var Player_velocity = $Samurai.velocity.x
	
	#print($Samurai.velocity.x)
	#print($Samurai.score)
	
	#
	## Farthest background (moves slowest)
	#$Bg/Parallax2D.scroll_offset.x -= Player_velocity * 0.05 * delta
	## Middle layer
	#$Bg/Parallax2D2.scroll_offset.x -= Player_velocity * 0.2 * delta
	## Front layer (moves fastest)
	#$Bg/Parallax2D3.scroll_offset.x -= Player_velocity * 0.1 * delta
	#
	## Wrapping background so it does not cut off
	#var parallax_layers = [$Bg/Parallax2D, $Bg/Parallax2D2, $Bg/Parallax2D3]
	#
	#for layer in parallax_layers:
		#var center = layer.get_child(0)
		#var left = layer.get_child(1)
		#var right = layer.get_child(2)
		#var w = center.texture.get_width() * center.scale.x
	#
		## Wrap scroll offset
		#layer.scroll_offset.x = fmod(layer.scroll_offset.x, w)
		#if layer.scroll_offset.x < 0:
			#layer.scroll_offset.x += w
	#
		## Position tiles relative to center
		#center.position.x = 0
		#left.position.x = -w
		#right.position.x = w
	#
	#$Ground.position.x -= speed * delta
	#
	##update ground position
	#if $Samurai/Camera2D.position.x - $Ground.position.x > screen_size.x:
		#$Ground.position.x += screen_size.x
	##if $Samurai/Camera2D.position.x - $Ground.position.x > screen_size.x:
		##$Ground.position.x += screen_size.x
	#
	
	
	
