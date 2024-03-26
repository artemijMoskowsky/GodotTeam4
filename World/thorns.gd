extends StaticBody2D

var damage = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_damage_zone_body_entered(body):
	if body.is_in_group("players"):
		body.get_damage(damage)
		body.return_to_floor = true
		
