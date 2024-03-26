extends Area2D

var vector = Vector2(0,0)
var linear_velocity
var speed = 6.5
var player 
var damage = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	linear_velocity = Vector2(-1,0).rotated(vector.angle()) * speed
	move(linear_velocity)

func move(linear_velocity):
	if speed < 0:
		vector = position - player.position
		# Vector2(1,1) или Vector2(0,1) делает прикольные вещи
		vector = Vector2(1,0).rotated(vector.angle()) * speed
	position += linear_velocity
	if speed > -5:
		speed -= 0.1
		
		
func _on_player_searcher_body_entered(body):
	if body.is_in_group("players"):
		player = body
		


func _on_body_entered(body):
	if body.is_in_group("players"):
		if speed < 0:
			body.can_spell1 = true
			queue_free()
	if body.is_in_group("Enemies"):
		body.get_damage(damage)


func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.is_in_group("switches"):
		area.activated = true
