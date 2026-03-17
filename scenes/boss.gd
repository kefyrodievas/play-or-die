extends CharacterBody2D

class_name Boss

const speed = 50
var is_boss_chase: bool = false
#if true - following player, false - roaming around randomly

var health = 200
var health_max = 200
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

func _process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0
	move(delta)
	handle_animation()
	move_and_slide()

func move(delta):
	if !dead:
		if !is_boss_chase:
			velocity += direction * speed * delta
		elif is_boss_chase and !taking_damage:
			var direction_to_player = position.direction_to($"../Samurai".playerBody.position) * speed
			velocity.x = direction_to_player.x #not gonna follow it upwards
			direction.x = abs(velocity.x) / velocity.x
		elif taking_damage:
			var knockback_direction = position.direction_to($"../Samurai".playerBody.position) * knockback_force
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
		elif direction.x == 1:
			anim_sprite.flip_h = false
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
	if !is_boss_chase:
		direction = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0

func choose(array):
	array.shuffle()
	return array.front()
