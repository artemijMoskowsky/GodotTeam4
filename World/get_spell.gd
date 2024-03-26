extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$PointLight2D.rotation += 0.01


func _on_body_entered(body):
	if body.is_in_group("players"):
		body.is_spell1_in_hero = true
		queue_free()
