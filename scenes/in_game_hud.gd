extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _set_highscore_val(value) -> void:
	$MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/NinePatchRect/HBoxContainer2/HighscoreNum.text = str(value)
	
func _set_hp_val(value: float) -> void:
	$MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/NinePatchRect/HealthBar.set_value_no_signal(value)
	#print($MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/HealthBar.value)
	#$MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/HealthBar.
func _set_score_val(value:int) -> void:
	$MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/NinePatchRect/HBoxContainer/ScoreNum.text = str(value)
