extends RigidBody2D

@export var start_x = 0
@export var end_x = 0
@export var speed: float = 1
@export var damage = 5
@export var health = 25

var animation
var direction = -1
var start_pos

var health_bar
const coin = preload("res://Items/coin.tscn")

var damage_cd: Timer
var flag_damage = false

var color_count = 255
var standart_modulate = modulate

# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = position
	start_x = start_pos.x - start_x
	end_x = start_pos.x + end_x
	animation = get_node("AnimatedSprite2D")
	health_bar = get_node("Health")
	damage_cd = get_node("damage_cd")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if color_count < 15:
		color_count += 1
	else:
		modulate = standart_modulate
	health_bar.value = health
	if start_x >= position.x:
		direction = 1
		$AnimatedSprite2D.flip_h = true
	elif position.x >= end_x:
		direction = -1
		$AnimatedSprite2D.flip_h = false

	if health <= 0:
		var coins_instance = coin.instantiate()
		coins_instance.position.x = position.x
		coins_instance.position.y = position.y - 25
		get_parent().add_child(coins_instance)
		queue_free()

	linear_velocity.x = direction * speed
	move_and_collide(linear_velocity)

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
