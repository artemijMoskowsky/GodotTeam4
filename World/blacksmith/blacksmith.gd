extends Area2D

@export var message_texts: PackedStringArray
var player
var message_lable
var mes_count = 0
var mes_viewed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			if player != null:
				if mes_viewed == true:
					if mes_count < len(message_texts)-1:
						mes_count += 1
						player.message_lable.view_text(message_texts[mes_count])
					if mes_count == len(message_texts)-1:
						player.message_lable.show_buttons()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		if player.action == true:
			mes_viewed = true
			player.message_lable.view_text(message_texts[mes_count])
			if mes_count == len(message_texts)-1:
				player.message_lable.show_buttons()
		if player.button_confirm == true:
			if	player.coins >= 10:
				player.button_confirm = false
				player.coins -= 10
				player.damage += 2
				player.message_lable.view_text("")
				player.message_lable.hide_buttons()
		if player.button_decline == true:
			mes_viewed = false
			player.button_decline = false
			player.message_lable.hide_buttons()
			player.message_lable.view_text("")

func _on_body_entered(body):
	if body.is_in_group("players"):
		player = body


func _on_body_exited(body):
	if body.is_in_group("players"):
		player = null
		mes_viewed = false
		body.message_lable.view_text("")
		body.message_lable.hide_buttons()
		




