extends Area2D

@export var target_scene: String = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body) -> void:
	if body.name == "Samurai":
		var next_scene = LevelManager.get_random_variant(target_scene)
		get_tree().call_deferred("change_scene_to_file", next_scene)
