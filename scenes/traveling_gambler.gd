extends CharacterBody2D

@export var next_scene: String = "res://scenes/CrazyGamble.tscn"

var player_in_range := false
var is_interacting := false
var damage := 999999
var kill := false
@onready var player = $"../Samurai"

func _ready():
	kill=false
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
		
func after_interaction():
	$Sprite2D.visible = false
	$SpeechBubbleGrey.visible = false
	$Label.visible = false
	$Label2.visible=false
	$AnimatedSprite2D.play("AFTER_GAMBLE")
	await $AnimatedSprite2D.animation_finished
	queue_free()
	
func start_interaction():
	is_interacting = true
	
	$AnimatedSprite2D.play("INTERACT")
	await $AnimatedSprite2D.animation_finished
	GameUi.open_gambler_menu()
	is_interacting = false
	
func KILL(body):
	$AnimatedSprite2D.play("KILL")
	await $AnimatedSprite2D.animation_finished
	kill = true
	if body.name == "Samurai":
		if body.has_method("take_damage"):
			body.take_damage(damage)
	
	$AnimatedSprite2D.play("IDLE")
	await get_tree().create_timer(5, true, false, true).timeout
	
	after_interaction()

func _on_area_2d_body_entered(body):
	if body.name == "Samurai" and !kill:
		player_in_range = true
		$Sprite2D.visible = false;
		$Label.visible = true;
	elif kill:
		$Sprite2D.visible = false;
		$Label.visible = false;
		$Label2.visible = true;


func _on_area_2d_body_exited(body):
	if body.name == "Samurai" and !kill:
		player_in_range = false
		$Sprite2D.visible = true;
		$Label.visible = false;
	elif kill:
		$Sprite2D.visible = false;
		$Label.visible = false;
		$Label2.visible = true;

		
