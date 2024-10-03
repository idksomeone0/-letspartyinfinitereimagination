extends Node3D

var barrier : Material = load("res://materials/barrier.tres")
@onready var ply = $"../.."
@onready var camera = $"../../Head/Camera3D"



var lastSelect
var lastMaterial
var onTask = false

var cooldown = 3.0
var oncool = false
var mode = 0
enum Mode {
	NO,
	MOVE,
	SCALE,
	ROTATE,
	ADD
}



var selected:
	set(value):
		selected = value
		if lastSelect:
			lastSelect.get_child(0).material_override = lastMaterial
			for serov in lastSelect.get_children():
					if serov.name.contains("@CSGSphere") or serov.name == "Handle":
						serov.queue_free()
		lastMaterial = selected.get_child(0).material_override
		lastSelect = selected
		print(lastSelect.name)
		var aabb = selected.get_child(0).mesh.get_aabb()
		var center = aabb.position + (aabb.size / 2)	
		var middle_faces = [
		center + Vector3(aabb.size.x / 2, 0, 0),  # Right face
		center - Vector3(aabb.size.x / 2, 0, 0),  # Left face
		center + Vector3(0, aabb.size.y / 2, 0),  # Top face
		center - Vector3(0, aabb.size.y / 2, 0),  # Bottom face
		center + Vector3(0, 0, aabb.size.z / 2),  # Front face
		center - Vector3(0, 0, aabb.size.z / 2),   # Back face
		]
		
		for c in middle_faces:
			var handles = load("res://scenes/xyzpresets/handle.tscn").instantiate()
			selected.add_child(handles)
			handles.position = c
	
	
var faceIndex = -1

func _process(delta):
	for thr in get_viewport().get_children():
		for thh in thr.get_children():
			for c in thh.get_children():
				if c.name.contains("@CSGSphere") or c.name == "Handle":
					pass
	
	if(Input.is_action_just_pressed("xyzadd")):
			mode = Mode.ADD
			print(mode)
	if(Input.is_action_just_pressed("xyzmove")):
		mode = Mode.MOVE
		print(mode)
	if Input.is_action_just_pressed("xyzscale"):
		mode = Mode.SCALE
		print(mode)
	if Input.is_action_just_pressed("xyzrotate"):
			mode = Mode.ROTATE
			print(mode)
	
	if Input.is_action_pressed("rightmouseclick"):
		ply.toggleLock(true)
	else:
		ply.toggleLock(false)
	
	if Input.is_action_just_pressed("itemMain") and not onTask:
		var mouse_pos = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mouse_pos)
		var to = from + camera.project_ray_normal(mouse_pos) * 1000  # Adjust the ray length as needed
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.new()
		query.from = from
		query.to = to
		query.collide_with_areas = true
		query.collide_with_bodies = true
		var result = space_state.intersect_ray(query)
		if result.has("collider"):
			print(result.collider.name + "reesult")
			if result.collider.is_in_group("selectable"):
				print(result.collider.name + "wss")
				selected = result.collider
				print(selected)

	match mode:
		0:
			pass
		Mode.MOVE: 
			if selected:
					pass
					
			else:
				pass
		Mode.SCALE:
			pass
		Mode.ROTATE:
			pass
		Mode.ADD:
			onTask = true
			if Input.is_action_just_pressed("itemMain"):
				var mouse_pos = get_viewport().get_mouse_position()
				var from = camera.project_ray_origin(mouse_pos)
				var to = from + camera.project_ray_normal(mouse_pos) * 1000  # Adjust the ray length as needed
				var space_state = get_world_3d().direct_space_state
				var query = PhysicsRayQueryParameters3D.new()
				query.from = from
				query.to = to
				query.collide_with_areas = true
				query.collide_with_bodies = true
				var result = space_state.intersect_ray(query)
				if(result.position):
					onTask = false
					var ins = load("res://scenes/xyzpresets/cubep.tscn").instantiate()
					get_viewport().add_child(ins)
					ins.position = result.position.round()
					mode = 1
					selected = ins
	

func _ready():
	ply.toggleLock(false)
	for thr in get_viewport().get_children():
		for thh in thr.get_children():
			for c in thh.get_children():
				if c.name.contains("@CSGSphere") or c.name == "Handle":
						c.queue_free()
						
