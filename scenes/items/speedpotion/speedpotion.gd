extends Node3D

@onready var righthand = $righthand
var cooldown = 30
var oncool = false
@onready var ply = $"../.."
@onready var sw_1 = $res/sw1
var lastSpeed 
@onready var circle = $res/Circle
var flaskMat = StandardMaterial3D.new()
var isPlayer

func _ready():
	ply.get_node("righthand").visible = false
	var newMat = StandardMaterial3D.new()
	newMat.albedo_color = ply.gInfo().color
	newMat.roughness = 1
	righthand.set_surface_override_material(0, newMat)
	flaskMat.diffuse_mode = BaseMaterial3D.DIFFUSE_TOON
	flaskMat.specular_mode = BaseMaterial3D.SPECULAR_TOON
	flaskMat.albedo_color = Color(0.549, 0.82, 0.328)
	circle.set_surface_override_material(1, flaskMat)
	
func _input(event):
	if is_multiplayer_authority():
		if Input.is_action_just_pressed("itemMain") and oncool == false:
			print("yes")
			oncool = true
			print("fire")
			sw_1.play()
			lastSpeed = ply.SPEED
			ply.SPEED = 10
			flaskMat.albedo_color = Color(0.1, 0.1, 0.1)
			await get_tree().create_timer(cooldown).timeout
			ply.SPEED = lastSpeed
			sw_1.play()
			await get_tree().create_timer(cooldown).timeout
			flaskMat.albedo_color = Color(0.549, 0.82, 0.328)
			print("unfire")
			oncool = false

func _process(delta):
	ply.get_node("righthand").visible = false
