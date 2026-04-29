extends CharacterBody2D

@export var next_scene: String = "res://scenes/CrazyGamble.tscn"

var player_in_range := false
var is_interacting := false
@onready var player = $"../Samurai"

func _ready():
	$AnimatedSprite2D.play("IDLE")
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
func _process(delta):

	
	if player.global_position.x < global_position.x:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	if player_in_range and !is_interacting and Input.is_action_just_pressed("Interact"):
		start_interaction()
		

func start_interaction():
	is_interacting = true
	
	$AnimatedSprite2D.play("INTERACT")
	
	await $AnimatedSprite2D.animation_finished
	GameUi.open_gambler_menu()
	is_interacting = false
	
func _on_area_2d_body_entered(body):
	if body.name == "Samurai":
		player_in_range = true
		$Sprite2D.visible = false;
		$Label.visible = true;
		print("Samurai entered NPC area")

func _on_area_2d_body_exited(body):
	if body.name == "Samurai":
		player_in_range = false
		print("Samurai exited NPC area")
		$Sprite2D.visible = true;
		$Label.visible = false;
