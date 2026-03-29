extends Control

var _is_paused = false:
	set(value):
		_is_paused = value
		get_tree().paused = _is_paused
		visible = _is_paused
		
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		_is_paused = ! _is_paused
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_btn_pressed() -> void:
	_is_paused = false


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
