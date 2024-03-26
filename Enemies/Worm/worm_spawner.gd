extends Node2D

@export var speed: int 
@export var radius: int 
@export var height: int
@export var start_moving: float 
@export var spawn_delay: float
var body_spawn_delay = spawn_delay + start_moving

const worm_head_scene = preload("res://Enemies/Worm/worm_head.tscn")
const worm_body_scene = preload("res://Enemies/Worm/worm_body.tscn")
const worm_tail_scene = preload("res://Enemies/Worm/worm_tail.tscn")
var worm_head = worm_head_scene.instantiate()
var worm_head_is_spawned = false
var body_count = 0
var body_was_spawned = false
var tail_was_spawned = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if worm_head_is_spawned == false:
		#worm_head.position.y = position.y
		#worm_head.position.x = position.x
		worm_head.center = position
		worm_head.radius = radius
		worm_head.time_delay = start_moving
		get_parent().add_child(worm_head)
		worm_head_is_spawned = true
	elif body_was_spawned == false:
		var worm_body = worm_body_scene.instantiate()
		#worm_body.position = position
		worm_body.center = position
		worm_body.radius = radius
		worm_body.time_delay = body_spawn_delay
		get_parent().add_child(worm_body)
		body_spawn_delay += spawn_delay
		if body_count == height:
			body_was_spawned = true
		body_count += 1
	elif tail_was_spawned == false:
		var worm_tail = worm_tail_scene.instantiate()
		#worm_tail.position = position
		worm_tail.center = position
		worm_tail.radius = radius
		worm_tail.time_delay = body_spawn_delay
		get_parent().add_child(worm_tail)
		tail_was_spawned = true

