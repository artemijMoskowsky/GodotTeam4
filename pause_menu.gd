extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_resume_pressed():
	get_tree().paused = false
	var children = get_tree().current_scene.get_children()
	for child in children:
		if child.is_in_group("players"):
			var player_children = child.get_children()
			for player_child in player_children:
				if player_child.is_in_group("pause_menu"):
					player_child.visible = false


func _on_exit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu.tscn")
