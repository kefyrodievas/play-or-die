extends Area2D

var respawn_time = 15.0
var start_position: Vector2

func _ready():
	body_entered.connect(_on_body_entered)
	start_position = position
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("Idle")

func apply_effect(body):
	pass  # override kiekviename powerupe

func _on_body_entered(body):
	if body.name == "Samurai":
		apply_effect(body)
		body.add_score(10)
		var tween = create_tween()
		tween.tween_property(self, "position", position + Vector2(0, -20), 0.3)
		tween.tween_property(self, "modulate:a", 0.0, 0.3)
		tween.tween_callback(_on_collected)

func _on_collected():
	hide()
	$CollisionShape2D.disabled = true
	position = start_position
	modulate.a = 1.0
	await get_tree().create_timer(respawn_time).timeout
	show()
	$CollisionShape2D.disabled = false
