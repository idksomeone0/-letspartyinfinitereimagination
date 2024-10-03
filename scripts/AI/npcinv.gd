extends Node

# What this does is take the invItem classes under the player's inventory, and generate the slots for them
# as well as loading the slots in if selected

var itemIndex
@onready var slots = $"../CanvasLayer/Control/HBoxContainer"
@onready var ply = $".."
var previous = " "
var onTask = false
var action:
	set(v):
		action = v
		print(str(v) + " twilight princess")
		if action == 1 and not onTask:
			action = null
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
				
	
		if action == 2 and not onTask:
			itemIndex = 0
			action = null
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
							
		if action == 3 and not onTask:
			itemIndex = 0
			action = null
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
		if action == 4 and not onTask:
			itemIndex = 0
			action = null
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





func act(n):
	action = n


func _process(delta):
	pass
	
func _on_text_edit_focus_entered():
	onTask = true




func _on_text_edit_focus_exited():
	onTask = false
