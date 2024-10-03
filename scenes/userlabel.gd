extends Label

@onready var ply = $"../../../../../../../.."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label_settings.outline_color = ply.gInfo().color

