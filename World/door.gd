extends StaticBody2D

var player_searcher
var player = null
var animation
var collision: CollisionShape2D
@export var is_opened: bool = false
@export var on_boss1_killed: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	player_searcher = get_node("Player_searcher")
	collision = $CollisionShape2D
	animation = $AnimatedSprite2D
	if is_opened == true:
		animation.play("default")
		collision.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		if player.action != false and collision.disabled == false and player.inventory_node.keys > 0 and is_opened == false and not on_boss1_killed:
			animation.play("default")
			collision.disabled = true
			player.inventory_node.keys -= 1
		elif on_boss1_killed and player.boss1_was_killed and collision.disabled == false:
			animation.play("default")
			collision.disabled = true
		


func _on_player_searcher_body_entered(body):
	if body.is_in_group("players"):
		player = body

func _on_player_searcher_body_exited(body):
	if body.is_in_group("players"):
		player = null
