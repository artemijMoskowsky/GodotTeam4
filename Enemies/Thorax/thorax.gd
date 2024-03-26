extends RigidBody2D

const SPEED = -0.06
var jump_count = 40
var is_jump = false
var jumping = false
var rng = RandomNumberGenerator.new()
var player
var direction = 1
var tilemaps = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rng.randomize()
	move_and_collide(linear_velocity)
	if player != null:
		if player.position.x > position.x:
			direction = 1
		else:
			direction = -1
	var chance = rng.randi_range(0, 50)
	jump(chance)


func _on_area_2d_body_entered(body):
	if body.is_in_group("TileMap"):
		tilemaps.append(body)


func _on_area_2d_body_exited(body):
	if body.is_in_group("TileMap"):
		if body in tilemaps:
			var index = tilemaps.find(body, 0)
			tilemaps.remove_at(index)

func jump(chance):
	if not is_jump and chance == 0:
		jumping = true
	elif is_jump and chance == 0 and tilemaps != []:
		jump_count = 40
		is_jump = false
		jumping = false
		
	if jumping == true:
		if jump_count != -41:
			is_jump = true
			linear_velocity.y = jump_count * SPEED
			linear_velocity.x = SPEED * -12 * direction
			jump_count -=1
			


func _on_search_body_entered(body):
	if body.is_in_group("players"):
		player = body

func _on_search_body_exited(body):
	if body.is_in_group("players"):
		player = null 
