extends Button

@onready var margin_container = $"../.."
@onready var panel = $"../../../Panel"

# Called when the node enters the scene tree for the first time.



func _on_button_up():
	margin_container.visible = false
	panel.visible = true
