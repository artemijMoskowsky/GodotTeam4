extends StaticBody2D

var was_fallen = false
var global_node
# Called when the node enters the scene tree for the first time.
func _ready():
	global_node = get_node("/root/Global")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global_node.platform1_was_fallen and not was_fallen:
		was_fallen = true
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite2D.play("default")

func _on_area_2d_body_entered(body):
	if body.is_in_group("players"):
		body.platform1_was_fallen = true
		$CollisionShape2D.set_deferred("disabled", true)
		if was_fallen == false:
			$AnimatedSprite2D.play("default")
			was_fallen = true
			$LightOccluder2D.visible = false
			$Stones.emitting = true
			$Stones2.emitting = true
			$Stones3.emitting = true
			$Stones4.emitting = true
			$Stones5.emitting = true
			$Stones6.emitting = true
			$Stones7.emitting = true
			$Stones8.emitting = true
			$Stones9.emitting = true
			$Stones10.emitting = true
			$Stones11.emitting = true
			$Stones12.emitting = true
			$Stones13.emitting = true
			$Stones14.emitting = true
			$Stones15.emitting = true
			$Stones16.emitting = true
			$Stones17.emitting = true
			$Stones18.emitting = true
			$Stones19.emitting = true
			$Stones20.emitting = true
			$Stones21.emitting = true
			$Stones22.emitting = true
			$Stones23.emitting = true
			$Stones24.emitting = true
			$Stones25.emitting = true
			$Stones26.emitting = true
			$Stones27.emitting = true
			$Stones28.emitting = true
			$Stones29.emitting = true
			$Stones30.emitting = true
			$Stones31.emitting = true
			$Stones32.emitting = true
			$Stones33.emitting = true
			$Stones34.emitting = true
			
