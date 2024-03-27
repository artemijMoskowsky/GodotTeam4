extends CharacterBody2D

var rng = RandomNumberGenerator.new()
const SPEED = 45.0
const JUMP_VELOCITY = -400.0
var jump_count = 40
var is_jump = false
var flag_attack_anim = false
var jumping = false
var boss_damage = 10
var is_damage = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation_player: AnimationPlayer
var direction = null
var player = null
var l_attack = []
var r_attack = []
var chance = 1
var jump_chance = 0
var can_jump = true
var jump_direction = 0
var health = 150
var flag_damage = false

var damage_cd: Timer

var color_count = 255
var standart_modulate = modulate

func _ready():
	animation_player = get_node("AnimationPlayer")
	damage_cd = get_node("DamageCD")
	
func _physics_process(delta):
	# Add the gravity.
	if color_count < 15:
		color_count += 1
	else:
		modulate = standart_modulate
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.x = SPEED * jump_direction * 2
	else:
		can_jump = true
		jump_direction = 0
		

	if player != null:
		if player.position.x > position.x:
			direction = 1
		else:
			direction = -1

	if direction == -1:
		$AnimatedSprite2D.flip_h = false
	if direction == 1:
		$AnimatedSprite2D.flip_h = true
	if $AnimatedSprite2D.animation == "Attack1" and $AnimatedSprite2D.frame != 6:
		direction = 0
	if direction:
		var vector = position.x - player.position.x
		if vector < 0:
			vector *= -1
		if vector > 75 and is_on_floor():
			is_damage = false
			velocity.x = direction * SPEED
			if is_on_floor():
				if is_damage == false and chance != 0:
					animation_player.play("Move")
		else:
			is_damage = true
			if is_on_floor():
				if velocity.x > 0:
					if velocity.x > SPEED:
						velocity.x -= SPEED
					else:
						velocity.x = 0
				elif velocity.x < 0:
					if velocity.x < SPEED * -1:
						velocity.x += SPEED
					else:
						velocity.x = 0
				if is_damage == false and chance != 0:
					animation_player.play("Idle")
	else:
		if is_on_floor():
			if is_damage == false and chance != 0:
				animation_player.play("Idle")

	if velocity.y <= 130:
		$Jump_kill.monitoring = false
	else:
		$Jump_kill.monitoring = true

	if is_damage == true:
		chance = rng.randi_range(0, 10)
		if chance == 0:
			animation_player.play("Attack1")
		if $AnimatedSprite2D.animation == "Attack1" and $AnimatedSprite2D.frame == 3 and is_on_floor():
			if $AnimatedSprite2D.flip_h:
				if r_attack != []:
					damage(r_attack[0], boss_damage, 1)
			elif not $AnimatedSprite2D.flip_h:
				if l_attack != []:
					damage(l_attack[0], boss_damage, -1)
		elif not is_on_floor():
			animation_player.play("Jump")
	jump_chance = rng.randi_range(0, 100)
	if player != null:
		if jump_chance == 1 and can_jump == true:
			if position.x > player.position.x:
				jump_direction = -1
			else:
				jump_direction = 1
			animation_player.play("Jump")
			velocity.y = -300
			can_jump = false
	if health <= 0:
		player.boss1_was_killed = true
		queue_free()
	
	move_and_slide()

func get_damage(gdamage):
	if not flag_damage:
		$damage_sound.play(0.0)
		flag_damage = true
		damage_cd.start()
		health -= gdamage
		modulate = Color(255,0,0)
		color_count = 0

func jump(chance):
	if not is_jump:
		jumping = true
	elif is_jump:
		jump_count = 40
		is_jump = false
		jumping = false
		
	if jumping == true:
		if jump_count != -41:
			is_jump = true

func damage(body, boss_damage, kickback):
	if is_damage == true:
		body.get_damage(boss_damage, kickback)


func _on_attack_left_body_entered(body):
	if body.is_in_group("players"):
		l_attack.append(body)


func _on_attack_left_body_exited(body):
	if body in l_attack:
		var index = l_attack.find(body, 0)
		l_attack.remove_at(index)


func _on_attack_right_body_entered(body):
	if body.is_in_group("players"):
		r_attack.append(body)

func _on_attack_right_body_exited(body):
	if body in r_attack:
		var index = r_attack.find(body, 0)
		r_attack.remove_at(index)




func _on_search_body_entered(body):
	if body.is_in_group("players"):
		player = body
	


func _on_jump_kill_body_entered(body):
	if body.is_in_group("players"):
		body.health = 0


func _on_damage_cd_timeout():
	flag_damage = false
