extends StaticBody2D

@export_file("*.tscn") var scene_path: String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("players"):
		# body.global_node.scene_count += 1
		# body.scene_count += 1
		# var scene_count = "res://Rooms/room%s.tscn"
		# scene_count = scene_count % body.scene_count
		# print(scene_count)
		get_tree().change_scene_to_file(scene_path)
		#get_tree().change_scene_to_file("")

