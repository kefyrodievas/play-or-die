extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)
	$AnimatedSprite2D.play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
	
func _on_body_entered(body):
	if body.name == "Samurai":
		
		# Activate doubler
		body.unlock_dash()
		
		# Optional: give points for collecting boots
		body.add_score(10)
		
		var tween = create_tween()
		tween.tween_property(self, "position",
			position + Vector2(0,-20), 0.3)
		
		tween.tween_property(self, "modulate:a", 0.0, 0.3)
		
		tween.tween_callback(self.queue_free)
