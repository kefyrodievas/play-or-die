extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -600.0


# SCORE SYSTEM
var score = 0
var score_multiplier = 1
var multiplier_time = 10.0

# JUMP SYSTEM
var max_jumps = 1
var jump_count = 0
var double_jump_duration = 20.0


func _physics_process(delta: float) -> void:
	
	# ANIMATION
	if velocity.x > 1 or velocity.x < -1:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")
	
	
	# GRAVITY
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Reset jumps on floor
	if is_on_floor():
		jump_count = 0
	
	# Jump logic
	if Input.is_action_just_pressed("Jump") and jump_count < max_jumps:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
	
	
	# MOVEMENT
	var direction := Input.get_axis("Move_left", "Move_right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		
		if abs(velocity.x) < 1:
			velocity.x = 0
	
	move_and_slide()
	
	if direction == 1.0:
		$AnimatedSprite2D.flip_h = false
	elif direction == -1.0:
		$AnimatedSprite2D.flip_h = true


# SCORE
func add_score(amount):
	score += amount * score_multiplier
	print("Score: ", score)


func activate_score_doubler():
	score_multiplier = 2
	#$AnimatedSprite2D.modulate = Color(1, 1, 0)
	$ScoreBoostTimer.start(multiplier_time)


func _on_score_boost_timer_timeout():
	score_multiplier = 1
	#$AnimatedSprite2D.modulate = Color(1, 1, 1)


# DOUBLE JUMP
func activate_double_jump():
	max_jumps = 2
	$DoubleJumpTimer.wait_time = double_jump_duration
	#$AnimatedSprite2D.modulate = Color(0, 1, 0) # GREEN for score boost
	$DoubleJumpTimer.start()

func _on_double_jump_timer_timeout():
	#print("Double jump ended")
	max_jumps = 1
	#$AnimatedSprite2D.modulate = Color(1, 1, 1) # Back to normal
	
