extends Area2D

@export var points := 50
var opened := false
var player_in_range := false
var player = null
var text = false;
func _ready():
	$AnimatedSprite2D.play("closed")
	

func _process(delta):
	$SpeechBubbleGrey.visible=text
	$Label.visible=text
	if player_in_range and !opened and Input.is_action_just_pressed("Interact"):
		open_chest()

func open_chest():
	opened = true
	
	if $AnimatedSprite2D:
		$AnimatedSprite2D.play("open")
	
	if player:
		player.add_score(points)
	
	print("Chest opened! Gave points: ", points)

func _on_body_entered(body):
	if body.name == "Samurai":
		player = body
		player_in_range = true
		text = true

func _on_body_exited(body):
	if body.name == "Samurai":
		player_in_range = false
		player = null
		text = false
