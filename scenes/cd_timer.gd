extends Control


var timer : Timer;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$p_bar.value = timer.time_left
	
func set_timer(timer_ : Timer):
	timer = timer_
	$p_bar.max_value = timer.wait_time 
	
