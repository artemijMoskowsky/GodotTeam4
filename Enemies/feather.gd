extends RigidBody2D

var vector
var speed = 4

#var life_cd: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	rotate(vector.angle())
	#look_at(Vector2(1,0).rotated(vector.angle()))
	#life_cd = get_node("Life")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#life_cd.start()
	linear_velocity = Vector2(1,0).rotated(vector.angle()) * speed
	move_and_collide(linear_velocity)
	
	


func _on_life_timeout():
	queue_free()


func _on_damage_body_entered(body):
	if body.is_in_group("players"):
		body.get_damage(5)
