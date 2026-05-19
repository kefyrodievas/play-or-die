extends CharacterBody2D

class_name Necromanx

@export var damage_to_deal := 50
var bodies_inside: Array = []

const speed = 50
var is_chasing: bool
#if true - following player, false - roaming around randomly

var health = 200
var health_max = 80
var health_min = 0

var dead: bool = false
var taking_damage: bool = false
var is_dealing_damage: bool = false
var is_attacking: bool = false

@export var attack_cooldown := 0.8
@export var attack_hit_time := 1.5

var can_attack := true
var player_in_attack_box := false

var direction: Vector2
const gravity = 900
var knockback_force = -20
var is_roaming: bool = true

var player_in_area = false
@onready var player: CharacterBody2D = $"../Samurai"

@export var chase_range := 200
@export var chase_y_range := 200
@export var attack_range := 55
var chase_speed = 150
var points = 10;



func _physics_process(delta):
	
	if !is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0
	move(delta)
	platform_edge()
	follow_and_attack_player()
	handle_animation()
	move_and_slide()

func move(delta):
	if dead:
		velocity.x = 0
		return

	if !is_chasing:
		velocity.x = direction.x * speed
	elif is_chasing and !taking_damage and !is_attacking:
		var direction_to_player = global_position.direction_to(player.global_position)
		velocity.x = direction_to_player.x * chase_speed

		if velocity.x != 0:
			direction.x = sign(velocity.x)
	elif taking_damage:
		var knockback_direction = global_position.direction_to(player.global_position) * knockback_force
		velocity.x = knockback_direction.x

	is_roaming = true

func handle_animation():
	var anim_sprite = $AnimatedSprite2D

	if dead:
		if is_roaming or is_dealing_damage:
			is_roaming = false
			is_dealing_damage = false
			anim_sprite.play("die")
			await get_tree().create_timer(1.0).timeout
			handle_death()
		return

	if is_attacking:
		return

	if taking_damage:
		anim_sprite.play("hurt")
		await get_tree().create_timer(0.5).timeout
		taking_damage = false
		return

	anim_sprite.play("walk")

	if direction.x == -1:
		anim_sprite.flip_h = true
	elif direction.x == 1:
		anim_sprite.flip_h = false

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
	if player == null or dead:
		return

	var boss_scale = abs(global_scale.x)

	var x_distance = abs(global_position.x - player.global_position.x)
	var y_distance = abs(global_position.y - player.global_position.y)

	var scaled_chase_range = chase_range * boss_scale
	var scaled_attack_range = attack_range * boss_scale

	if x_distance < scaled_chase_range and y_distance < chase_y_range:
		is_chasing = true

		var player_side = sign(player.global_position.x - global_position.x)
		if player_side != 0:
			direction.x = player_side

		if x_distance < scaled_attack_range:
			is_dealing_damage = true

			if !is_attacking:
				_attack()
		else:
			is_dealing_damage = false
	else:
		is_chasing = false
		is_dealing_damage = false

#Attack animation
func _attack():
	if is_attacking or !can_attack:
		return

	is_attacking = true
	can_attack = false
	is_dealing_damage = true
	velocity.x = 0
	is_roaming = false

	$AnimatedSprite2D.play("attack")

	await get_tree().create_timer(attack_hit_time).timeout

	_deal_attack_damage()

	await $AnimatedSprite2D.animation_finished

	is_attacking = false
	is_dealing_damage = false
	is_roaming = true

	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
	
func _deal_attack_damage():
	for body in bodies_inside:
		if body != null and body.name == "Samurai" and body.has_method("take_damage"):
			body.take_damage(damage_to_deal)
			
func _on_attack_box_body_entered(body):
	if body.name == "Samurai":
		if body not in bodies_inside:
			bodies_inside.append(body)
		player_in_attack_box = true

func _on_attack_box_body_exited(body):
	if body.name == "Samurai":
		player_in_attack_box = false
	bodies_inside.erase(body)


func drop_loot():
	# Base 30% chance + 5% per Luck Level (up to 50% at level 4)
	var drop_chance = 0.3 + (GameData.luck_level * 0.05)
	if randf() <= drop_chance:
		spawn_random_powerup()
		
		
func get_boss_bottom_position() -> Vector2:
	var collision := $CollisionShape2D
	var shape = collision.shape
	
	var bottom_offset := 0.0
	
	if shape is CapsuleShape2D:
		bottom_offset = shape.height * 0.5 * abs(scale.y)-abs(scale.y)*15
	else:
		bottom_offset = 40.0
	
	return global_position + Vector2(0, bottom_offset)
	
func spawn_random_powerup():
	var items = [ preload("res://scenes/jump_boost.tscn"), 
	preload("res://scenes/Damage_boost.tscn"), 
	preload("res://scenes/Boots.tscn"),
	preload("res://scenes/random.tscn"),
	preload("res://scenes/star.tscn")
	]
	var item_instance = items.pick_random().instantiate()
	# 1. Get the current scale of this enemy (the boss)
	var item_size = abs(player.scale.x/3)
	print(item_size)
	print(player.global_scale.x)
	# 3. Apply the scale
	item_instance.scale = Vector2(item_size,item_size)
	get_parent().add_child(item_instance)
	item_instance.global_position = get_boss_bottom_position()
