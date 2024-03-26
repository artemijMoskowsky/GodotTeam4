extends Node2D

var keys: int = 0
var key_label
var global_node
# Called when the node enters the scene tree for the first time.
func _ready():
	key_label = get_node("KeyLabel")
	global_node = get_node("/root/Global")
	keys = global_node.keys

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if key_label != null:
		key_label.text = str(keys)
