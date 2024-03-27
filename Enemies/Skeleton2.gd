extends RigidBody2D

@export var speed: float = 1
@export var damage = 5
@export var health = 25
var direction = 1
var player
var health_bar
var player_in_dmg = false

const coin = preload("res://Items/coin.tscn")

var damage_cd: Timer
var can_damage = false

var flag_damage = false

var l_objects = []
var r_objects = []

var color_count = 255
var standart_modulate = modulate

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar = get_node("Health")
	damage_cd = get_node("Damage_cd")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health_bar.value = health
	if color_count < 15:
		color_count += 1
	else:
		modulate = standart_modulate
	if player != null:
		if player.position.x < position.x - 10:
			direction = -1
			$AnimatedSprite2D.flip_h = true
		elif player.position.x > position.x + 10:
			direction = 1
			$AnimatedSprite2D.flip_h = false
		else:
			direction = 0
		if player_in_dmg == false:
			if direction == -1 and l_objects != []:
				$AnimationPlayer.play("Run")
				linear_velocity.x = speed * direction
				move_and_collide(linear_velocity)
			elif direction == 1 and r_objects != []:
				$AnimationPlayer.play("Run")
				linear_velocity.x = speed * direction
				move_and_collide(linear_velocity)
			else:
				$AnimationPlayer.play("Idle")
			if direction == 0:
				$AnimationPlayer.play("Idle")
		else:
			$AnimationPlayer.play("Attack")
	else:
		$AnimationPlayer.play("Idle")

	if player_in_dmg:
		# if can_damage:
		if $AnimatedSprite2D.animation == "Attack" and $AnimatedSprite2D.frame == 7:
			# damage_cd.start()
			player.get_damage(damage)
			# can_damage = false
	if health <= 0:
		var coins_instance = coin.instantiate()
		coins_instance.position.x = position.x
		coins_instance.position.y = position.y - 25
		get_parent().add_child(coins_instance)
		queue_free()

func _on_view_body_entered(body):
	if body.is_in_group("players"):
		player = body


func _on_view_body_exited(body):
	if body.is_in_group("players"):
		player = null


func _on_damage_zone_body_entered(body):
	if body.is_in_group("players"):
		player_in_dmg = true

func _on_damage_zone_body_exited(body):
	if body.is_in_group("players"):
		player_in_dmg = false

func get_damage(damage):
	if not flag_damage:
		$damage_sound.play(0.0)
		flag_damage = true
		damage_cd.start()
		health -= damage
		modulate = Color(255,0,0)
		color_count = 0

func _on_damage_cd_timeout():
	can_damage = true
	flag_damage = false


func _on_left_falling_body_entered(body):
	if not body.is_in_group("players"):
		l_objects.append(body)

func _on_left_falling_body_exited(body):
	if body in l_objects:
		var index = l_objects.find(body, 0)
		l_objects.remove_at(index)


func _on_right_falling_body_entered(body):
	if not body.is_in_group("players"):
		r_objects.append(body)
	

func _on_right_falling_body_exited(body):
	if body in r_objects:
		var index = r_objects.find(body, 0)
		r_objects.remove_at(index)
