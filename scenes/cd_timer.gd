extends Control


var timer : Timer;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer == null or not is_instance_valid(timer):
		queue_free()
		return
	$p_bar.value = timer.time_left
	#print(timer.time_left)
	if timer.time_left == 0:
		self.queue_free()
	
func set_timer(timer_ : Timer):
	#print("AAAAAAAAAAAAAAAAAAAAa\n")
	timer = timer_
	$p_bar.max_value = timer.wait_time 
	
