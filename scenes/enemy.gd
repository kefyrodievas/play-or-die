extends CharacterBody2D

class_name EnemySkeleton

const speed = 50
var is_chasing: bool
#if true - following player, false - roaming around randomly

var health = 80
var health_max = 80
var health_min = 0

var dead: bool = false
var taking_damage: bool = false
var damage_to_deal = 6
var is_dealing_damage: bool = false

var direction: Vector2
const gravity = 900
var knockback_force = -20
var is_roaming: bool = true

var player_in_area = false
var player: CharacterBody2D

var attack_range = 80
var chase_speed = 150

func _process(delta):
	player = $"../Samurai".playerBody
	
	if !is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0
		
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
		else:
			is_dealing_damage = false
			
	else:
		is_chasing = false

#Attack animation
func _attack():
	is_dealing_damage = true
	velocity.x = 0
	is_roaming = false
	$AnimatedSprite2D.play("attack")
	await get_tree().create_timer(1.0).timeout
	
