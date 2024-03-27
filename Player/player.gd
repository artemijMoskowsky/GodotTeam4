extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var global_node
var scene_count: int
var animation_player: AnimationPlayer
var health: int = 50
var health_bar
var damage = 5
var damage_cd: Timer
var can_damage = true
var attack_cd: Timer
var can_attack = true
var coins = 0
var coins_label
var flag_attack = "r"
var flag_attack_anim = false
var attack_anim_timer: Timer
var audio_step: AudioStreamPlayer2D
var message_lable

#var move_r: TouchScreenButton
#var move_l: TouchScreenButton
#var view_u: TouchScreenButton
#var view_d: TouchScreenButton
var button_jump: TouchScreenButton
var button_attack: TouchScreenButton
var button_pause: TouchScreenButton
var button_spell1: TouchScreenButton

var bg_music = false

var is_spell1_in_hero = false
var platform1_was_fallen
var boss1_was_killed

var r_enemies = []
var l_enemies = []
var u_enemies = []
var d_enemies = []
var recoil = 0
var kickback = 0
var flag_damage = false
var return_to_floor = false
var last_pos = Vector2(0, 0)
var action = false
var button_confirm = false
var button_decline = false
var vector = Vector2(0,0)
var spell1 = true
var spell1_scene = preload("res://Player/spell1.tscn")

# var spell1_obj = spell1_scene.instantiate()
var can_spell1 = true

var joystick

var inventory_node

#@export var joystick_left : VirtualJoystick

# var move_vector := Vector2.ZERO

var g_position

func _ready():
	animation_player = get_node("AnimationPlayer")
	global_node = get_node("/root/Global")
	scene_count = get_node("/root/Global").scene_count
	health = get_node("/root/Global").health
	g_position = get_node("/root/Global").player_position
	coins = global_node.coins
	platform1_was_fallen = get_node("/root/Global").platform1_was_fallen
	boss1_was_killed = get_node("/root/Global").boss1_was_killed
	if g_position != null:
		position = g_position
	health_bar = get_node("Health")
	damage_cd = get_node("damage_cd")
	attack_cd = get_node("attack_cd")
	coins_label = get_node("coins_label")
	attack_anim_timer = get_node("attack_anim")
	audio_step = get_node("step")
	#move_r = get_node("MoveRight")
	#move_l = get_node("MoveLeft")
	button_jump = get_node("ButtonJump")
	button_attack = get_node("ButtonAttack")
	button_pause = get_node("ButtonPause")
	#view_u = get_node("ViewUp")
	#view_d = get_node("ViewDown")
	joystick = get_node("joystick/Joyring")
	
	inventory_node = get_node("Inventory")
	inventory_node.keys = global_node.keys
	message_lable = get_node("Message")
	is_spell1_in_hero = global_node.is_spell1_in_hero
	button_spell1 = get_node("ButtonSpell1")
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += 600 * delta
		if velocity.y > 300:
			velocity.y = 300
	else:
		last_pos = position
	if bg_music == false:
		$background_music.play(0.0)
		bg_music = true
		
	if return_to_floor:
		position = last_pos
		return_to_floor = false
	#if joystick_left and joystick_left.is_pressed:
		#position += joystick_left.output * SPEED * delta
#
	### Movement using Input functions:
	#move_vector = Vector2.ZERO
	#move_vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	#position += move_vector * SPEED * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	var direction = Input.get_axis("moveLeft", "moveRight")

	if Input.is_key_pressed(KEY_W) or joystick.parent.posVector.y < -0.6:
		action = true
	else:
		action = false
	if joystick != null:
		if joystick.parent.posVector.x > 0.3:
			direction = 1
		elif joystick.parent.posVector.x < -0.3:
			direction = -1

	if button_jump != null:
		if button_jump.is_pressed() and is_on_floor():
			velocity.y = JUMP_VELOCITY
			animation_player.play("Jump")

	if button_attack != null:
		if button_attack.is_pressed():
			attacking()
	if button_pause != null:
		if button_pause.is_pressed():
			global_node.pause_event = true

	if direction == -1:
		$AnimatedSprite2D.flip_h = true
	if direction == 1:
		$AnimatedSprite2D.flip_h = false
	if direction:
		velocity.x = direction * SPEED + recoil
		recoil = 0
		if is_on_floor():
			if not flag_attack_anim:
				animation_player.play("Run")
	else:
		if kickback == 0 and recoil == 0:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if recoil != 0:
			velocity.x = recoil/3
		recoil = 0
		if kickback != 0:
			velocity.x = kickback
		kickback = 0
		if is_on_floor():
			if not flag_attack_anim:
				animation_player.play("Idle")
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation_player.play("Jump")


	if Input.is_key_pressed(KEY_X):
		attacking()

	if flag_attack_anim == true:
		if d_enemies != [] and flag_attack == "d":
			for enemy in d_enemies:
				if enemy.is_in_group("Enemies"):
					enemy.get_damage(damage)
			velocity.y = -200
		elif u_enemies != [] and flag_attack == "u":
			for enemy in u_enemies:
				if enemy.is_in_group("Enemies"):
					enemy.get_damage(damage)
		elif l_enemies != [] and flag_attack == "l":
			for enemy in l_enemies:
				if enemy.is_in_group("Enemies"):
					enemy.get_damage(damage)
			#recoil = 225
		elif r_enemies != [] and flag_attack == "r":
			for enemy in r_enemies:
				if enemy.is_in_group("Enemies"):
					enemy.get_damage(damage)
			#recoil = -225

	if Input.is_action_just_pressed("Spell") and can_spell1 and is_spell1_in_hero:
		vector = Vector2(0,0)
		var is_input = true
		if Input.is_key_pressed(KEY_W):
			vector.y = 1
			is_input = true
		elif Input.is_key_pressed(KEY_S):
			vector.y = -1
			is_input = true
		else:
			is_input = false
		if Input.is_key_pressed(KEY_D):
			vector.x = -1
			is_input = true
		elif Input.is_key_pressed(KEY_A):
			vector.x = 1
			is_input = true
		if is_input == false:
			if $AnimatedSprite2D.flip_h:
				vector.x = 1
			else:
				vector.x = -1
		can_spell1 = false
		var spawn_spell = spell1_scene.instantiate()
		spawn_spell.position = position
		spawn_spell.vector = vector
		#spawn_spell.speed = 5
		get_parent().add_child(spawn_spell)
	elif button_spell1.is_pressed() and can_spell1 and is_spell1_in_hero:
		vector = joystick.parent.posVector
		vector *= -1
		if vector == Vector2(0,0):
			if $AnimatedSprite2D.flip_h:
				vector.x = 1
			else:
				vector.x = -1
		can_spell1 = false
		
		var spawn_spell = spell1_scene.instantiate()
		spawn_spell.position = position
		spawn_spell.vector = vector
		#spawn_spell.speed = 5
		get_parent().add_child(spawn_spell)




	#if Input.is_action_just_pressed("Save"):
		#var json_file = JSON.new()
		#var file = FileAccess.open("res://Saves/Save_1.json", FileAccess.WRITE)
		#
		#var save = {"position": position, "health": health, "scene_count": scene_count}
		#file.store_string(json_file.stringify(save))
		#file.close()
	
	if $AnimatedSprite2D.animation == "Run":
		if $AnimatedSprite2D.frame == 3 or $AnimatedSprite2D.frame == 9:
			audio_step.play(0.0)
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision != null:
			var collider = collision.get_collider()
			if collider != null:
				if collider.is_in_group("Enemies"):
					if not collider.is_in_group("Boss"):
						get_damage(collision.get_collider().damage)
					else:
						get_damage(collision.get_collider().boss_damage)
	if health <= 0:
		health = 0
		get_tree().reload_current_scene()
	health_bar.value = health

	coins_label.text = str(coins)

	move_and_slide()

func attacking():
	if can_attack:
		$attack.play(0.0)
		flag_attack_anim = true
		attack_anim_timer.start()
		animation_player.play("Attack")
		if Input.is_key_pressed(KEY_W) or joystick.parent.posVector.y < -0.6:
			$Attack_anim.position.x = 0
			$Attack_anim.position.y = -18
			$Attack_anim.flip_h = false
			if flag_attack != "u":
				$Attack_anim.rotate(-1.57079633)
			if flag_attack == "d":
				$Attack_anim.rotate(-1.57079633)
			flag_attack = "u"
		elif Input.is_key_pressed(KEY_S) or joystick.parent.posVector.y > 0.6:
			$Attack_anim.position.x = 0
			$Attack_anim.position.y = 18
			$Attack_anim.flip_h = false
			if flag_attack != "d":
				$Attack_anim.rotate(1.57079633)
			if flag_attack == "u":
				$Attack_anim.rotate(1.57079633)
			flag_attack = "d"
		elif $AnimatedSprite2D.flip_h == true:
			#for enemy in l_enemies:
				#enemy.health -= damage
			$Attack_anim.flip_h = true
			$Attack_anim.position.x = -22
			$Attack_anim.position.y = 0
			if flag_attack == "u":
				$Attack_anim.rotate(1.57079633)
			elif flag_attack == "d":
				$Attack_anim.rotate(-1.57079633)
			flag_attack = "l"
		else:
			#for enemy in r_enemies:
				#enemy.health -= damage
			$Attack_anim.flip_h = false
			$Attack_anim.position.x = 18
			$Attack_anim.position.y = 0
			if flag_attack == "u":
				$Attack_anim.rotate(1.57079633)
			elif flag_attack == "d":
				$Attack_anim.rotate(-1.57079633)
			flag_attack = "r"
		attack_cd.start()
		can_attack = false
		$Attack_anim.play("default")

func get_damage(damage, get_kickback = null):
	if not flag_damage:
		$damage_sound.play(0.0)
		flag_damage = true
		damage_cd.start()
		health -= damage
		if get_kickback != null:
			if get_kickback == 1:
				position.y += 1
				velocity.y = -100
				kickback = 500
			else:
				position.y += 1
				velocity.y = -100
				kickback = -500

func _on_damage_cd_timeout():
	flag_damage = false


func _on_r_attack_body_entered(body):
	if body.is_in_group("Enemies") or body.is_in_group("sword_jump"):
		r_enemies.append(body)
		
		
func _on_r_attack_body_exited(body):
	if body in r_enemies:
		var index = r_enemies.find(body, 0)
		r_enemies.remove_at(index)
		# for i in r_enemies:
		# 	print([i])
		
	

func _on_l_attack_body_entered(body):
	if body.is_in_group("Enemies") or body.is_in_group("sword_jump"):
		l_enemies.append(body)


func _on_l_attack_body_exited(body):
	if body in l_enemies:
		var index = l_enemies.find(body, 0)
		l_enemies.remove_at(index)


func _on_attack_cd_timeout():
	can_attack = true


func _on_attack_anim_timeout():
	flag_attack_anim = false


func _on_u_attack_body_entered(body):
	if body.is_in_group("Enemies") or body.is_in_group("sword_jump"):
		u_enemies.append(body)


func _on_u_attack_body_exited(body):
	if body in u_enemies:
		var index = u_enemies.find(body, 0)
		u_enemies.remove_at(index)


func _on_d_attack_body_entered(body):
	if body.is_in_group("Enemies") or body.is_in_group("sword_jump"):
		d_enemies.append(body)


func _on_d_attack_body_exited(body):
	if body in d_enemies:
		var index = d_enemies.find(body, 0)
		d_enemies.remove_at(index)


func _on_background_music_finished():
	bg_music = false
