extends Area2D

@export var indexes: PackedStringArray
var enemies = []
var flag_wave_just_changed = true
var max_indexes_len
var wave = 0
var wave_was_passed = false
var is_player = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if max_indexes_len == null:
		max_indexes_len = indexes.size() - 1
	if is_player == true:
		if enemies == []:
			var spawner_indexes = indexes[wave].split(",")
			var children_count = get_child_count()
			for i in children_count:
				var child = get_child(i)
				for sp_in in spawner_indexes:
					if child.is_in_group('spawner_' + sp_in):
						child.is_activated = true
	
			if flag_wave_just_changed == false:	
				wave += 1
				flag_wave_just_changed = true
				if wave > max_indexes_len:
					wave = max_indexes_len
					wave_was_passed = true
					var children_count2 = get_child_count()
					for i in children_count2:
						var child2 = get_child(i)
						if child2.is_in_group("wave_door"):
							child2.collision.set_deferred("disabled", true)
							child2.animation.play("default")
func _on_body_entered(body):
	if body.is_in_group('Enemies'):
		enemies.append(body)
		flag_wave_just_changed = false		
	elif body.is_in_group('players') and wave_was_passed == false:
		is_player = true
		var children_count = get_child_count()
		for i in children_count:
			var child = get_child(i)
			if child.is_in_group("wave_door"):
				child.collision.set_deferred("disabled", false)
				child.animation.play("reverse")


func _on_body_exited(body):
	if body in enemies:
		var index = enemies.find(body)
		enemies.remove_at(index)
	elif body.is_in_group('players'):
		is_player = false
