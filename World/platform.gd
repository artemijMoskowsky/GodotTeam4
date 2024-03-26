extends StaticBody2D

var animation
var collision
# Called when the node enters the scene tree for the first time.
func _ready():
	animation = get_node("AnimatedSprite2D")
	collision = get_node("CollisionShape2D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
