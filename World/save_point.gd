extends Area2D


var player
var light_rot = 0.1
var light_en = 0.0
var can_save = true
var global_scene
# Called when the node enters the scene tree for the first time.
func _ready():
	global_scene = get_node("/root/Global")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		if player.action and can_save:
			$Save_cd.start()
			can_save = false
			$AnimatedSprite2D.play("activated")
			save(player)
	if not can_save:
		$PointLight2D.rotation += light_rot
		if light_rot > 0:
			light_rot -= 0.001
		$PointLight2D.energy = light_en
		if light_en < 0.2:
			light_en += 0.02
	else:
		light_rot = 0.1
		light_en = 0
		if $PointLight2D.energy > 0.0:
			$PointLight2D.energy -= 0.02


func _on_body_entered(body):
	if body.is_in_group("players"):
		player = body


func _on_body_exited(body):
	if body.is_in_group("players"):
		player = null


func _on_save_cd_timeout():
	can_save = true


func save(player):
	var json_file = JSON.new()
	var file = FileAccess.open("res://Saves/Save_1.json", FileAccess.WRITE)
	player.health = 50
	var save = {"x": player.position.x, "y": player.position.y, "health": player.health, "scene_count": player.scene_count, "coins": player.coins, "keys": player.inventory_node.keys, "platform1_was_fallen": player.platform1_was_fallen, "boss1_was_killed": player.boss1_was_killed, "spell1": player.is_spell1_in_hero}
	file.store_string(json_file.stringify(save))
	file.close()
	global_scene.health = player.health
	global_scene.scene_count = player.scene_count
	global_scene.player_position = Vector2(player.position.x, player.position.y)
	global_scene.platform1_was_fallen = player.platform1_was_fallen
	global_scene.boss1_was_killed = player.boss1_was_killed
	global_scene.keys = player.inventory_node.keys
	global_scene.coins = player.coins
	global_scene.is_spell1_in_hero = player.is_spell1_in_hero
