extends RigidBody2D

@export var start_x = 0
@export var end_x = 0
@export var speed = 5

var animation_player
var direction = -1
var start_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = position
	start_x = start_pos.x - start_x
	end_x = start_pos.x + end_x
	animation_player = get_node("AnimationPlayer")
	$AnimatedSprite2D.flip_h = true



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if start_x >= position.x:
		direction = 1
		$AnimatedSprite2D.flip_h = false
	elif position.x >= end_x:
		direction = -1
		$AnimatedSprite2D.flip_h = true

	linear_velocity.x = direction * speed
	animation_player.play("Run")
	move_and_collide(linear_velocity)
