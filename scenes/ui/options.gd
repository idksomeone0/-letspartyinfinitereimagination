extends Button

@onready var margin_container = $"../../../../../../MarginContainer"
@onready var panel = $"../../../../.."

var boolean = false

func _on_button_up():
	if boolean == false:
		boolean = true
		margin_container.visible = false
		panel.visible = true
	if boolean == true:
		boolean = false
		margin_container.visible = true
		panel.visible = false
