extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -600.0


func _physics_process(delta: float) -> void:
	
	# Add animation
	if velocity.x > 1 or velocity.x < -1:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	#else:
		#$AnimatedSprite2D.play("run")

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
