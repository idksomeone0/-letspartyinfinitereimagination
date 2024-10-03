extends Node3D


func switchScene(scene):
	
	if scene == "testMap":
		print(get_tree().current_scene.get_children())
		for v in self.get_children():
			v.queue_free()
		await get_tree().create_timer(0.5).timeout
		add_child(load("res://test.tscn").instantiate())


