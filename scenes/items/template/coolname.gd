extends Node3D

var cooldown = 3.0
var oncool = false

func _process(delta):
	if Input.is_action_just_pressed("itemMain") and oncool == false:
		oncool = true
		# instant logic here
		print("fire")
		
		await get_tree().create_timer(cooldown).timeout
		# after logic here	
		
		print("unfire")
		oncool = false



