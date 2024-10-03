extends Node3D

var cooldown = 0.5
var oncool = false
@onready var ply = $"../.."
@onready var righthand = $righthand
var isPlayer

func _process(delta):
	ply.get_node("righthand").visible = false

func _ready():
	var newMat = StandardMaterial3D.new()
	newMat.albedo_color = ply.gInfo().color
	newMat.roughness = 1
	righthand.set_surface_override_material(0, newMat)
