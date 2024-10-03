extends Control

@onready var text_edit = $TextureRect/MarginContainer/MarginContainer/GridContainer/TextEdit
@onready var color_picker_button = $TextureRect/MarginContainer/MarginContainer/GridContainer/ColorPickerButton



var newSave = PlayerSave.new()
var dir = DirAccess.open("user://")
var loadedSave

# Called when the node enters the scene tree for the first time.
func _ready():
	if !dir.file_exists("savedata.tres"):
		ResourceSaver.save(newSave, "user://savedata.tres")
	else:
		loadedSave = load("user://savedata.tres")
		if loadedSave.username and loadedSave.skin_color:
			text_edit.text = loadedSave.username
			color_picker_button.color = loadedSave.skin_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if loadedSave:
		loadedSave.username = text_edit.text
		loadedSave.skin_color = color_picker_button.color
		ResourceSaver.save(loadedSave, "user://savedata.tres")
