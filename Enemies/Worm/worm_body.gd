extends RigidBody2D

var timer: Timer
var center: Vector2
var d := 0.0
var speed := 1.5
var radius := 150.0
var direction: Vector2
var can_move = false
var time_delay: float = 1.0
# Called when the node enters the scene tree for the first time.
func _ready():
	timer = get_node('Timer')
	timer.wait_time = time_delay
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_move:
		d += delta
		direction = Vector2(sin(d * speed) * radius,
							cos(d * speed) * radius) + center
		look_at(direction)
		position = direction


func _on_timer_timeout():
	can_move = true


func _on_damage_zone_body_entered(body):
	if body.is_in_group("players"):
		body.get_damage(15)
