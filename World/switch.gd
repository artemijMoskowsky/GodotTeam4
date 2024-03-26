extends Area2D

var activated = false
var was_activated = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if activated == true:
		if was_activated == false:
			$AnimatedSprite2D.play("activated")
			was_activated = true
		var children_count = get_child_count()
		for i in children_count:
			var child = get_child(i)
			if child.is_in_group("doors"):
				if child.collision.disabled == false:
					child.collision.set_deferred("disabled", true)
					child.animation.play("default")
			elif child.is_in_group("platforms"):
				if child.collision.disabled == true:
					child.collision.set_deferred("disabled", false)
					child.animation.play("default")
