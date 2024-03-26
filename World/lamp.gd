extends Node2D

var light: PointLight2D
var light_first_energy
var rng = RandomNumberGenerator.new()
var blink_cd: Timer
var blinking = false
var can_blink = true
# Called when the node enters the scene tree for the first time.
func _ready():
	light = get_node("PointLight2D")
	blink_cd = get_node("Blink_Cd")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if light_first_energy == null:
		light_first_energy = light.energy
	else:
		rng.randomize()
		var chance = rng.randf_range(0.01, light_first_energy/1.5)
		if not blinking:
			if can_blink:
				blinking = true
				can_blink = false
				blink_cd.start()
			else:
				if light.energy < light_first_energy:
					light.energy += 0.01
		else:
			if light.energy > chance:
				light.energy -= 0.01
			else:
				blinking = false
		
	


func _on_blink_cd_timeout():
	can_blink = true
	var chance2 = rng.randi_range(2, 5)
	blink_cd.wait_time = chance2
