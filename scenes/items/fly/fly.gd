extends Node3D


var cooldown = 0.1
var oncool = false
var fl = false
@onready var ply = $"../.."
@onready var sw_1 = $res/sw1
var effect = ShaderMaterial.new()
var lastSpeed 
var oldMat
var debounce = false
var isPlayer

	
func _input(event):
	if is_multiplayer_authority():
		if Input.is_action_just_pressed("itemMain") and oncool == false and fl == false and debounce == false:
			debounce = true
			print("yes")
			oncool = true
			print("fire")
			fl = true
			ply.flying = true
			sw_1.play()
			effect.shader = load("res://materials/special mats/Barrier.tres")
			effect.set_shader_parameter("Color", ply.gInfo().color)
			oldMat = ply.get_node("fbody").get_active_material(0)
			ply.get_node("fbody").set_surface_override_material(0, effect)
			lastSpeed = ply.SPEED
			ply.SPEED = 20
			await get_tree().create_timer(cooldown).timeout
			debounce = false
			
			print("unfire")
			oncool = false
		elif Input.is_action_just_pressed("itemMain") and oncool == false and fl == true and debounce == false:
			fl = false
			debounce = true
			ply.flying = false
			oncool = true
			ply.SPEED = lastSpeed
			ply.get_node("fbody").set_surface_override_material(0, oldMat)
			ply.velocity = Vector3.ZERO
			await get_tree().create_timer(cooldown).timeout
			debounce = false
			oncool = false
