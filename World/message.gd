extends Label

var confirm
var decline

# Called when the node enters the scene tree for the first time.
func _ready():
	confirm = get_node("Confirm")
	decline = get_node("Decline")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func view_text(mes_text):
	text = mes_text
	
func show_buttons():
	confirm.visible = true
	decline.visible = true

func hide_buttons():
	decline.visible = false
	confirm.visible = false

func _on_confirm_pressed():
	get_parent().button_confirm = true
	


func _on_decline_pressed():
	get_parent().button_decline = true
