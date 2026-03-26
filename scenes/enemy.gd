extends CharacterBody2D

class_name EnemySkeleton

const speed = 50
var is_skeleton_chase: bool
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

func _process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0
		player = $"../Samurai".playerBody
	move(delta)
	handle_animation()
	move_and_slide()
	platform_edge()
	follow_player()

func move(delta):
	if !dead:
		if !is_skeleton_chase:
			velocity += direction * speed * delta
		elif is_skeleton_chase and !taking_damage:
			var direction_to_player = position.direction_to(player.position) * speed
			velocity.x = direction_to_player.x #not gonna follow it upwards
			direction.x = abs(velocity.x) / velocity.x
		elif taking_damage:
			var knockback_direction = position.direction_to(player.position) * knockback_force
			velocity.x = knockback_direction.x
		is_roaming = true
	elif dead:
		velocity.x = 0
	

func handle_animation():
	var anim_sprite = $AnimatedSprite2D
	if !dead and !taking_damage and !is_dealing_damage:
		anim_sprite.play("walking")
		if direction.x == -1:
			anim_sprite.flip_h = true
			#$RayCast2D.position.x *= -1
		elif direction.x == 1:
			anim_sprite.flip_h = false
			#$RayCast2D.position.x *= -1
	elif !dead and taking_damage and !is_dealing_damage:
		anim_sprite.play("hurt")
		await get_tree().create_timer(0.72).timeout
		taking_damage = false
	elif dead and is_roaming:
		is_roaming = false
		anim_sprite.play("dying")
		await get_tree().create_timer(1.0).timeout
		handle_death()
	elif !dead and is_dealing_damage:
		anim_sprite.play("attack")

func handle_death():
	self.queue_free()
	#additional stuff like giving points for killing enemy

#RANDOM MOVEMENT
func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time = choose([1.5,2.0,2.5,3.0,3.5])
	if !is_skeleton_chase:
		direction = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0
		

func choose(array):
	array.shuffle()
	return array.front()

#TAKE DAMAGE
func _on_hitbox_area_entered(area):
	if area.name == "AttackArea2D":
		take_damage($"../Samurai".damage)
		
func take_damage(damage):
	health -= damage
	taking_damage = true
	if health <= health_min:
		health = health_min
		dead = true
	print(str(self), "current health dis ", health)
	
#STAY ON PLATFORM
func platform_edge():
	if not $RayCast2D.is_colliding():
		direction = -direction
		$RayCast2D.position.x *= -1
		
func follow_player():
	if not $RayCast2D2.is_colliding():
		is_skeleton_chase = false
		print(is_skeleton_chase)
	else:
		is_skeleton_chase = true 
		print(is_skeleton_chase)
