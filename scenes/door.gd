extends Area2D

@export var target_scene: String = ""

var player_inside: Node2D = null

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact") and player_inside != null:
		if player_inside.has_method("save_player_state"):
			player_inside.save_player_state()
		
		GameData.current_floor += 1
		
		var next_scene = LevelManager.get_random_variant(target_scene)
		get_tree().call_deferred("change_scene_to_file", next_scene)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Samurai":
		player_inside = body
		$DungeonTileSet.visible = true
		if(GameData.current_floor==0):
			$SpeechBubbleGrey.visible = true
			$Label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body == player_inside:
		player_inside = null
		$DungeonTileSet.visible = false
		if(GameData.current_floor==0):
			$SpeechBubbleGrey.visible = false
			$Label.visible = false
