extends Area2D

var player
var opened_note_scene = preload("res://World/opened_note.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		if player.action:
			var opened_note = opened_note_scene.instantiate()
			opened_note.position = Vector2(-100,-170)
			player.add_child(opened_note)
			get_tree().paused = true


func _on_body_entered(body):
	if body.is_in_group("players"):
		player = body

func _on_body_exited(body):
	if body.is_in_group("players"):
		player = null
