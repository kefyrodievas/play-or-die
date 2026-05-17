extends CharacterBody2D

class_name Satyr

@export var damage_to_deal := 10
@export var tick_time := 4
var bodies_inside: Array = []

const speed = 50
var is_chasing: bool
#if true - following player, false - roaming around randomly

var health = 80
var health_max = 80
var health_min = 0

var dead: bool = false
var taking_damage: bool = false
var is_dealing_damage: bool = false

var direction: Vector2
const gravity = 900
var knockback_force = -20
var is_roaming: bool = true

var player_in_area = false
var player: CharacterBody2D

var attack_range = 80
var chase_speed = 150
var points = 2

func _process(delta):
	player = $"../Samurai".playerBody
	
	if !is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0
		
	var timer = Timer.new()
	timer.wait_time = tick_time
	timer.autostart = true
	timer.timeout.connect(_on_tick)
	add_child(timer)
	
	move(delta)
	platform_edge()
	follow_and_attack_player()
	handle_animation()
	move_and_slide()

func move(delta):
	if !dead:
		if !is_chasing:
			velocity += direction * speed * delta
		elif is_chasing and !taking_damage:
			var direction_to_player = position.direction_to(player.position) * chase_speed
			velocity.x = direction_to_player.x #not gonna follow it upwards
			direction.x = abs(velocity.x) / velocity.x
		elif taking_damage:
			#This needs fixing
			var knockback_direction = position.direction_to(player.position) * knockback_force
			velocity.x = knockback_direction.x
		is_roaming = true
	elif dead:
		velocity.x = 0

func handle_animation():
	var anim_sprite = $AnimatedSprite2D
	if !dead and !taking_damage and !is_dealing_damage:
		anim_sprite.play("walk")
		if direction.x == -1:
			anim_sprite.flip_h = true
		elif direction.x == 1:
			anim_sprite.flip_h = false
	elif !dead and taking_damage and !is_dealing_damage:
		anim_sprite.play("hurt")
		await get_tree().create_timer(0.5).timeout
		taking_damage = false
	elif (dead and is_roaming) or (dead and is_dealing_damage):
		is_roaming = false
		is_dealing_damage = false
		anim_sprite.play("die")
		await get_tree().create_timer(1.0).timeout
		handle_death()

func handle_death():
	drop_loot()
	var current_level = max(0, GameData.current_floor)
	var final_reward = points + current_level * 5
	$"../Samurai".call_deferred("add_score", final_reward)
	self.queue_free()
	#additional stuff like giving points for killing enemy

#Random movement
func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time = choose([1.5,2.0,2.5,3.0,3.5])
	if !is_chasing:
		direction = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0

func choose(array):
	array.shuffle()
	return array.front()

#Take damage from player
func _on_hitbox_area_entered(area):
	if area.name == "AttackArea2D":
		take_damage($"../Samurai".damage)

func take_damage(damage):
	health -= damage
	taking_damage = true
	if health <= health_min:
		health = health_min
		dead = true
	print(str(self), "current health is ", health)
	
#Stay on current platform
func platform_edge():
	if is_on_floor():
		if direction.x < 0 and not $ground_left.is_colliding():
			is_chasing = false	
			_flip()
		elif direction.x > 0 and not $ground_right.is_colliding():
			is_chasing = false	
			_flip()

func _flip():
	direction *= -1
	velocity.x = 0

#Follow and attack player if close enough
func follow_and_attack_player():
	if global_position.distance_to(player.global_position) < 300 and (abs(global_position.y - player.global_position.y) < 17) and !dead:
		is_chasing = true
		if global_position.distance_to(player.global_position) < attack_range:
			var temp = sign(player.global_position.x - global_position.x)
			if (temp < 0 and direction.x > 0) or (temp > 0 and direction.x < 0):
				direction *= -1
			_attack()
			is_dealing_damage = true
		else:
			is_dealing_damage = false
			
	else:
		is_chasing = false

#Attack animation
func _attack():
	velocity.x = 0
	is_roaming = false
	$AnimatedSprite2D.play("attack")
	await get_tree().create_timer(1.0).timeout
	
func _on_attack_box_body_entered(body):
	if body.name == "Samurai":
		if body not in bodies_inside:
			bodies_inside.append(body)
		if body.has_method("take_damage") and is_dealing_damage:
			body.take_damage(damage_to_deal)

func _on_attack_box_body_exited(body):
	bodies_inside.erase(body)

func _on_tick():
	for body in bodies_inside:
		if body.has_method("take_damage") and is_dealing_damage:
			body.take_damage(damage_to_deal)

func drop_loot():
	# Base 30% chance + 5% per Luck Level (up to 50% at level 4)
	var drop_chance = 0.3 + (GameData.luck_level * 0.05)
	if randf() <= drop_chance:
		spawn_random_powerup()
		
func spawn_random_powerup():
	var items = [ preload("res://scenes/jump_boost.tscn"), 
	preload("res://scenes/Damage_boost.tscn"), 
	preload("res://scenes/Boots.tscn"),
	preload("res://scenes/random.tscn"),
	preload("res://scenes/star.tscn")
	]
	var item_instance = items.pick_random().instantiate()
	# Makes it 30% of its original size
	item_instance.scale = Vector2(0.3, 0.3)
	get_parent().add_child(item_instance) # Add to level, not enemy
	item_instance.global_position = global_position
