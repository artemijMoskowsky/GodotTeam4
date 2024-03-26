extends StaticBody2D

@export_file("*.tscn") var enemy_path: String
@export var is_activated: bool
@export var count: int
var spawned_enemy
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_activated == true:
		if enemy_path != null:
			if count > 0:
				var enemy = load(enemy_path)
				spawned_enemy = enemy.instantiate()
				spawned_enemy.position = global_position
				get_parent().get_parent().add_child(spawned_enemy)
				count -= 1
				is_activated = false
