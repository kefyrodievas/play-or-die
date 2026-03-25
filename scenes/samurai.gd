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

#DAMAGE SYSTEM
var damage = 6
var damage_multiplier = 1
var damage_boost_duration = 10.0

#HEALTH SYSTEM
var health = 100
var is_Alive: bool = true
var taking_damage: bool = false

#ATTACK SYSTEM
const hitbox := preload("res://scenes/attack_hitbox.tscn")
const cd_timer := preload("res://scenes/cd_timer.gd")
var inAttack = false

var playerBody = self

func _physics_process(delta: float) -> void:
	
	# ANIMATION
	if velocity.x > 1 or velocity.x < -1:
		$AnimatedSprite2D.play("run")
	elif inAttack:
		$AnimatedSprite2D.play("attack")
	elif is_Alive and taking_damage:
		#velocity = Vector2.ZERO
		$AnimatedSprite2D.play("hurt")
		await get_tree().create_timer(0.3).timeout
		taking_damage = false
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
	
	if Input.is_action_just_pressed("Dash") and canDash:
		activate_dash()
		
	# Attack logic
	if Input.is_action_just_pressed("Attack_up"):
		attack(Vector2.UP)
	elif Input.is_action_just_pressed("Attack_down"):
		attack(Vector2.DOWN)
	elif Input.is_action_just_pressed("Attack_left"):
		attack(Vector2.LEFT)
	elif Input.is_action_just_pressed("Attack_right"):
		attack(Vector2.RIGHT)
	
	# MOVEMENT
	var direction := Input.get_axis("Move_left", "Move_right")
	
	if not is_dashing:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * delta / 0.3)
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
	$CanvasLayer/InGameHUD.call("_set_score_val", score)

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
	

#DASH
var canDash = false
var is_dashing = false
var dashSpeed = 1200
var dashDuration = 0.2
var dashCooldown = 1.0

func unlock_dash():
	canDash = true

func activate_dash():
	canDash = false
	is_dashing = true
	var dash_direction = 1.0 if not $AnimatedSprite2D.flip_h else -1.0
	velocity.x = dash_direction * dashSpeed
	
	var dash_timer = get_tree().create_timer(dashDuration)
	dash_timer.timeout.connect(func():
		is_dashing = false
	)
	
	var cooldown_timer = get_tree().create_timer(dashDuration + dashCooldown)
	cooldown_timer.timeout.connect(func():
		canDash = true
	)
	
func unlock_damage_boost():
	damage_multiplier *= 2
	var timer = get_tree().create_timer(damage_boost_duration)
	timer.timeout.connect(func():
		damage_multiplier /= 2 
	)

#TAKING DAMAGE FROM ENEMY
func _on_s_hitbox_area_entered(area):
	if (area.name == "DealDamageHitbox"):
		take_damage($"../Enemy".damage_to_deal)

func take_damage(damage_to_take):
	if damage_to_take != 0:
		if health > 0:
			taking_damage = true
			health -= damage_to_take
			print(str(self), "current health is ", health)
	$CanvasLayer/InGameHUD.call("_set_hp_val", health)




# ATTACK
var can_attack = true
var attack_cd = 0.4
var attack_duration = 0.2
var attack_inst

func attack(direction):
	if can_attack:
		attack_inst = hitbox.instantiate()
		if direction == Vector2.UP:
			attack_inst.call_deferred("_rotate", -90.0)
		elif direction == Vector2.LEFT:
			attack_inst.call_deferred("_rotate", 180.0)
		elif direction == Vector2.DOWN:
			attack_inst.call_deferred("_rotate", 90.0)	
		add_child(attack_inst, true)
		can_attack = false
		inAttack = true
		attack_timers()

func attack_timers():
	var cooldown_timer = get_tree().create_timer(attack_cd)
	var dest_timer = get_tree().create_timer(attack_duration)
	cooldown_timer.timeout.connect(func():
		can_attack = true
		)
	dest_timer.timeout.connect(func():
		attack_inst.free()
		inAttack = false
		)
	
