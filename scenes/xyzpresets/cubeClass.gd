extends Node3D
class_name xyzObj

@onready var cube = $part1
@export var faces = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var aabb = cube.get_aabb()
	var center = aabb.position + (aabb.size / 2)
	faces = [
	center + Vector3(aabb.size.x / 2, 0, 0),  # Right face
	center - Vector3(aabb.size.x / 2, 0, 0),  # Left face
	center + Vector3(0, aabb.size.y / 2, 0),  # Top face
	center - Vector3(0, aabb.size.y / 2, 0),  # Bottom face
	center + Vector3(0, 0, aabb.size.z / 2),  # Front face
	center - Vector3(0, 0, aabb.size.z / 2),   # Back face
					]
