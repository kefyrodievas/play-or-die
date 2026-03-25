extends Area2D

# Define the possible types
var boost_types = ["star", "jump", "dash", "damage"]

func _ready():
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
	
func _on_body_entered(body):
	if body.name == "Samurai":
		
		# 1. Randomize the boost (0 to 3)
		var effect_roll = randi() % 4
		body.add_score(10)
		match effect_roll:
			0:
				body.activate_score_doubler() # Star effect
				print("Rolled: Score Doubler")
			1:
				body.activate_double_jump() # Jump boost
				print("Rolled: Double Jump")
			2:
				body.unlock_dash() # Dash boots
				print("Rolled: Dash Unlock")
			3:
				body.unlock_damage_boost() # Damage boost
				print("Rolled: Damage Boost")
		
		
		
		# 4. Feedback Animation (Moving up + Fading)
		# We set monitoring to false so it can't be triggered again during the tween
		monitoring = false
		
		var tween = create_tween()
		tween.tween_property(self, "position",
			position + Vector2(0,-20), 0.3)
		
		tween.tween_property(self, "modulate:a", 0.0, 0.3)
		
		tween.tween_callback(self.queue_free)
