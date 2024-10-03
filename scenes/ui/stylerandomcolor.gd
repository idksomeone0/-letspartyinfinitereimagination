extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_theme_stylebox_override("hello", load("res://resources/def style.tres"))
	
