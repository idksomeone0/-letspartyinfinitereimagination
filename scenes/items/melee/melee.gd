extends Node3D
# Combo Item Template
@onready var sw_2 = $res/sw2
@onready var ply = $"../.."
@onready var anim = $AnimationPlayer
@onready var hit_box = $hitBox
@onready var timer = $Timer
@onready var righthand = $righthand
@onready var lefthand = $lefthand


var cooldown = 0
var oncool = false
var current
var dBounce
var combon = 0
var vdamage = 30
var isPlayer

func _ready():
	var newMat = StandardMaterial3D.new()
	newMat.albedo_color = ply.gInfo().color
	newMat.roughness = 1
	righthand.set_surface_override_material(0, newMat)
	lefthand.set_surface_override_material(0, newMat)

func _process(delta):
	ply.get_node("righthand").visible = false
	ply.get_node("lefthand").visible = false
	if Input.is_action_just_pressed("itemMain") and oncool == false:
		# instant logic here
		ply.switchOnTask(true)
		if combon == 0:
			anim.play("fists1")
			dBounce = true		# Here so that it only damages once
			timer.start()
			while anim.is_playing():
				await get_tree().create_timer(0.01).timeout
				ply.velocity = lerp(ply.velocity, ply.velocity * Vector3(0.1, 0.1, 0.1), 0.08)
				react()
			combon = 1
			ply.switchOnTask(false)
		elif combon == 1:
			anim.play("fists2")
			dBounce = true
			timer.start()
			while anim.is_playing():
				await get_tree().create_timer(0.01).timeout
				ply.velocity = lerp(ply.velocity, ply.velocity * Vector3(0.1, 0.1, 0.5), 0.08)
				react()
			combon = 2
			ply.switchOnTask(false)
			oncool = true
			combon = 0
			await get_tree().create_timer(cooldown).timeout
			# after logic here	
			print("unfire")
			oncool = false


func react():
	for current in hit_box.get_overlapping_bodies():
		if current.is_in_group("entity") or current.is_in_group("player") and current.name != ply.name:
			if dBounce == true:
				damage(current, vdamage)
				dBounce = false
	


func damage(emt, dmh):
	emt.sHealth(emt.gHealth() - dmh)
	emt.lastHit = ply
func _on_hit_box_body_exited(body):
	current = body
	print("entered")


func _on_timer_timeout():
	combon = 0
	anim.queue("dfswordidle")
	
