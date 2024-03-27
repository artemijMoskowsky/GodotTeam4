extends RigidBody2D

@export var speed: float = 3
@export var damage = 5
@export var health = 25

var player
var player_in_dmg = false
var attack_cd: Timer
var can_attack = true
var health_bar
var flag_damage = false
var damage_cd
const coin = preload("res://Items/coin.tscn")

const FEATHER = preload("res://Enemies/feather.tscn")

var up_count = 0

var color_count = 255
var standart_modulate = modulate

# Called when the node enters the scene tree for the first time.
func _ready():
	attack_cd = get_node("Attack_cd")
	health_bar = get_node("Health")
	damage_cd = get_node("damage_cd")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health_bar.value = health
	if color_count < 15:
		color_count += 1
	else:
		modulate = standart_modulate
	if up_count != 0:
		linear_velocity.y = -2
	$AnimationPlayer.play("Fly")
	if $AnimatedSprite2D.frame == 3:
		$flying.play(0.0)
	if player != null and not player_in_dmg:
		linear_velocity = (player.position - position)/speed/20
		if player.position.x < position.x:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	if player_in_dmg:
		#print(linear_velocity)
		linear_velocity.lerp(Vector2(0,0), delta*speed)
		if can_attack:
			can_attack = false
			attack_cd.start()
			var feather = FEATHER.instantiate()
			feather.vector = (player.position - global_position).normalized()
			feather.position = position
			get_parent().add_child(feather)

	if health <= 0:
		var coins_instance = coin.instantiate()
		coins_instance.position.x = position.x
		coins_instance.position.y = position.y - 25
		get_parent().add_child(coins_instance)
		queue_free()
	move_and_collide(linear_velocity)
func _on_view_body_entered(body):
	if body.is_in_group("players"):
		player = body

func _on_view_body_exited(body):
	if body.is_in_group("players"):
		player = null


func _on_damage_body_entered(body):
	if body.is_in_group("players"):
		player_in_dmg = true

func _on_damage_body_exited(body):
	if body.is_in_group("players"):
		player_in_dmg = false


func _on_attack_cd_timeout():
	can_attack = true


func _on_up_body_entered(body):
	up_count += 1


func _on_up_body_exited(body):
	up_count -= 1

func get_damage(damage):
	if not flag_damage:
		$damage_sound.play(0.0)
		flag_damage = true
		damage_cd.start()
		health -= damage
		modulate = Color(255,0,0)
		color_count = 0

func _on_damage_cd_timeout():
	flag_damage = false
