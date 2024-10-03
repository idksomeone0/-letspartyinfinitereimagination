extends Node

# What this does is take the invItem classes under the player's inventory, and generate the slots for them
# as well as loading the slots in if selected

var itemIndex
@onready var slots = $"../CanvasLayer/Control/HBoxContainer"
@onready var ply = $".."
var previous = " "
var onTask = false

func updateInv():
	var icons = $"../CanvasLayer/Control/HBoxContainer"
	for item in icons.get_children():
		item.queue_free()
		
	itemIndex = 0
	for item in get_children():
		itemIndex += 1
		var slot = load("res://scenes/ui/slot.tscn").instantiate()
		slots.add_child(slot)
		slot.name = str(itemIndex)
		slot.dotext(item.itemName)


func _ready():
	updateInv()


func _process(delta):
	if is_multiplayer_authority():
		if Input.is_action_just_pressed("sel1") and not onTask:
			if previous == "sel1":
				for item in get_children():
					if item.name.contains("activeSlot"):
							item.queue_free()
				var icons = $"../CanvasLayer/Control/HBoxContainer"
				for icon in icons.get_children():
					icon.enableSlot(false)
				previous = " "
				return
			previous = "sel1"
			ply.toggleLock(true)
			itemIndex = 0
			for item in get_children():
				if item.name.contains("activeSlot"):
						item.queue_free()
				itemIndex += 1
				if itemIndex == 1:
					
					print("res://scenes/items/" + item.name + "/" + item.name + ".tscn")
					var active = load("res://scenes/items/" + item.name + "/" + item.name + ".tscn").instantiate()
					print(active)
					add_child(active)
					active.name = "activeSlot"
					active.isPlayer = true
					var icons = $"../CanvasLayer/Control/HBoxContainer"
					for icon in icons.get_children():
						if icon.name == str(itemIndex):
							icon.enableSlot(true)
						else:
							icon.enableSlot(false)
				
	
		if Input.is_action_just_pressed("sel2") and not onTask:
			itemIndex = 0
			if previous == "sel2":
				for item in get_children():
					if item.name.contains("activeSlot"):
							item.queue_free()
				var icons = $"../CanvasLayer/Control/HBoxContainer"
				for icon in icons.get_children():
					icon.enableSlot(false)
				previous = " "
				return
			previous = "sel2"
			ply.toggleLock(true)
			for item in get_children():
				if item.name.contains("activeSlot"):
						item.queue_free()
				itemIndex += 1
				if itemIndex == 2:
					
					print("res://scenes/items/" + item.name + "/" + item.name + ".tscn")
					var active = load("res://scenes/items/" + item.name + "/" + item.name + ".tscn").instantiate()
					print(active)
					add_child(active)
					active.name = "activeSlot"
					var icons = $"../CanvasLayer/Control/HBoxContainer"
					for icon in icons.get_children():
						if icon.name == str(itemIndex):
							icon.enableSlot(true)
						else:
							icon.enableSlot(false)
							
		if Input.is_action_just_pressed("sel3") and not onTask:
			itemIndex = 0
			if previous == "sel3":
				for item in get_children():
					if item.name.contains("activeSlot"):
							item.queue_free()
				var icons = $"../CanvasLayer/Control/HBoxContainer"
				for icon in icons.get_children():
					icon.enableSlot(false)
				previous = " "
				return
			previous = "sel3"
			ply.toggleLock(true)
			for item in get_children():
				if item.name.contains("activeSlot"):
						item.queue_free()
				itemIndex += 1
				if itemIndex == 3:
					
					print("res://scenes/items/" + item.name + "/" + item.name + ".tscn")
					var active = load("res://scenes/items/" + item.name + "/" + item.name + ".tscn").instantiate()
					print(active)
					add_child(active)
					active.name = "activeSlot"
					var icons = $"../CanvasLayer/Control/HBoxContainer"
					for icon in icons.get_children():
						if icon.name == str(itemIndex):
							icon.enableSlot(true)
						else:
							icon.enableSlot(false)
		if Input.is_action_just_pressed("sel4") and not onTask:
			itemIndex = 0
			if previous == "sel4":
				for item in get_children():
					if item.name.contains("activeSlot"):
							item.queue_free()
				var icons = $"../CanvasLayer/Control/HBoxContainer"
				for icon in icons.get_children():
					icon.enableSlot(false)
				previous = " "
				return
			previous = "sel4"
			ply.toggleLock(true)
			for item in get_children():
				if item.name.contains("activeSlot"):
						item.queue_free()
				itemIndex += 1
				if itemIndex == 4:
					
					print("res://scenes/items/" + item.name + "/" + item.name + ".tscn")
					var active = load("res://scenes/items/" + item.name + "/" + item.name + ".tscn").instantiate()
					print(active)
					add_child(active)
					active.name = "activeSlot"
					var icons = $"../CanvasLayer/Control/HBoxContainer"
					for icon in icons.get_children():
						if icon.name == str(itemIndex):
							icon.enableSlot(true)
						else:
							icon.enableSlot(false)
	updateInv()


func _on_text_edit_focus_entered():
	onTask = true




func _on_text_edit_focus_exited():
	onTask = false
