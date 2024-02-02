extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var global_node
var scene_count: int
var animation_player

func _ready():
	animation_player = get_node("AnimationPlayer")
	global_node = get_node("/root/Global")
	scene_count = get_node("/root/Global").scene_count
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("moveLeft", "moveRight")

	if direction == -1:
		$AnimatedSprite2D.flip_h = true
	if direction == 1:
		$AnimatedSprite2D.flip_h = false
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor():
			animation_player.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			animation_player.play("Idle")

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation_player.play("Jump")

	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_file("res://menu.tscn")
	
	
	
	move_and_slide()
