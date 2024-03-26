extends Node2D

var scene_count: int = 1
var health: int = 50
var player_position = null
var keys = 0
var coins = 0

var platform1_was_fallen = false
var boss1_was_killed = false
var is_spell1_in_hero = false

var pause_event = false
var inventory_event = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Pause") or pause_event == true:
		pause_event = false
		if get_tree().paused:
			get_tree().paused = false
			var children = get_tree().current_scene.get_children()
			for child in children:
				if child.is_in_group("players"):
					var player_children = child.get_children()
					for player_child in player_children:
						if player_child.is_in_group("pause_menu"):
							player_child.visible = false
		else:
			get_tree().paused = true
			var children = get_tree().current_scene.get_children()
			for child in children:
				if child.is_in_group("players"):
					var player_children = child.get_children()
					for player_child in player_children:
						if player_child.is_in_group("pause_menu"):
							player_child.visible = true
	if Input.is_action_just_pressed("Inventory") or inventory_event == true:
		inventory_event = false
		if get_tree().paused:
			get_tree().paused = false
			var children = get_tree().current_scene.get_children()
			for child in children:
				if child.is_in_group("players"):
					var player_children = child.get_children()
					for player_child in player_children:
						if player_child.is_in_group("Inventory"):
							player_child.visible = false
		else:
			get_tree().paused = true
			var children = get_tree().current_scene.get_children()
			for child in children:
				if child.is_in_group("players"):
					var player_children = child.get_children()
					for player_child in player_children:
						if player_child.is_in_group("Inventory"):
							player_child.visible = true
