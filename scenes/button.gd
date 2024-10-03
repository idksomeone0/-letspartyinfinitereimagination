extends Button

@export var item : invItem
@onready var hotbar = $"../../../../../../../../../../../Hotbar"


func giveItem():
	print("yes")
	var newItem = invItem.new()
	newItem.name = item.name
	newItem.itemName = item.itemName
	hotbar.add_child(newItem)

func _ready():
	button_down.connect(giveItem)
	
