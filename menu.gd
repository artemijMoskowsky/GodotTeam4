extends Node2D


const room1 = preload("res://Rooms/room1.tscn")

var global_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	global_scene = get_node("/root/Global")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Rooms/room1.tscn")
	var json_file = JSON.new()
	var file = FileAccess.open("res://Saves/Save_1.json", FileAccess.WRITE)
	var save = {"x": -155, "y": 325, "health": 50, "scene_count": 1, "keys": 0, "platform1_was_fallen": false, "boss1_was_killed": false, "spell1": false}
	file.store_string(json_file.stringify(save))
	file.close()
	global_scene.health = 50
	global_scene.scene_count = 1
	global_scene.player_position = Vector2(-155, 325)
	global_scene.platform1_was_fallen = false
	global_scene.boss1_was_killed = false


func _on_exit_pressed():
	get_tree().quit()


func _on_continue_pressed():
	var file = FileAccess.open("res://Saves/Save_1.json", FileAccess.READ)
	var json = JSON.new()
	var content = json.parse_string(file.get_as_text())
	global_scene.health = content["health"]
	global_scene.scene_count = content["scene_count"]
	global_scene.player_position = Vector2(content["x"], content["y"])
	global_scene.platform1_was_fallen = content["platform1_was_fallen"]
	global_scene.boss1_was_killed = content["boss1_was_killed"]
	global_scene.keys = content["keys"]
	global_scene.is_spell1_in_hero = content["spell1"]
	global_scene.coins = content["coins"]
	var room = "res://Rooms/room%s.tscn" % content["scene_count"]
	get_tree().change_scene_to_file(room)
