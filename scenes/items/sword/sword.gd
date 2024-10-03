extends Node3D
# Combo Item Template
@onready var sw_2 = $res/sw2
@onready var ply = $"../.."
@onready var anim = $AnimationPlayer
@onready var hit_box = $hitBox
@onready var timer = $Timer
@onready var righthand = $righthand


var cooldown = 0.1
var oncool = false
var current
var dBounce
var combon = 0
var vdamage = 50
var isPlayer = true
var hitv


func _ready():
	var newMat = StandardMaterial3D.new()
	newMat.albedo_color = ply.gInfo().color
	newMat.roughness = 1
	righthand.material = newMat


func hit():
	hitv = true
	await get_tree().process_frame
	hitv = false

func _process(delta):
	ply.get_node("righthand").visible = false
	if Input.is_action_just_pressed("itemMain") and oncool == false and isPlayer == true:
		if is_multiplayer_authority():
			# instant logic here
			ply.switchOnTask(true)
			if combon == 0:
				anim.play("dfswordswing1")
				dBounce = true		# Here so that it only damages once
				timer.start()
				while anim.is_playing():
					await get_tree().process_frame
					ply.velocity = lerp(ply.velocity, ply.velocity * Vector3(0.1, 0.1, 0.1), 0.08)
					react()
				combon = 1
				ply.switchOnTask(false)
			elif combon == 1:
				anim.play("dfswordswing2")
				dBounce = true
				timer.start()
				while anim.is_playing():
					await get_tree().process_frame
					ply.velocity = lerp(ply.velocity, ply.velocity * Vector3(0.1, 0.1, 0.5), 0.08)
					react()
				combon = 2
				ply.switchOnTask(false)
			elif combon == 2:
				anim.play("dfswordswing3")
				dBounce = true
				timer.start()
				while anim.is_playing():
					await get_tree().process_frame
					ply.velocity = lerp(ply.velocity, ply.velocity * Vector3(0.1, 0.1, 0.7), 0.08)
					react()
				
				ply.switchOnTask(false)
				oncool = true
				combon = 0
				await get_tree().create_timer(cooldown).timeout
				# after logic here	
				print("unfire")
				oncool = false
	if hitv and oncool == false and not isPlayer:
		# instant logic here
		ply.switchOnTask(true)
		if combon == 0:
			anim.play("dfswordswing1")
			dBounce = true		# Here so that it only damages once
			timer.start()
			while anim.is_playing():
				await get_tree().process_frame
				ply.velocity = lerp(ply.velocity, ply.velocity * Vector3(0.1, 0.1, 0.1), 0.08)
				react()
			combon = 1
			ply.switchOnTask(false)
		elif combon == 1:
			anim.play("dfswordswing2")
			dBounce = true
			timer.start()
			while anim.is_playing():
				await get_tree().process_frame
				ply.velocity = lerp(ply.velocity, ply.velocity * Vector3(0.1, 0.1, 0.5), 0.08)
				react()
			combon = 2
			ply.switchOnTask(false)
		elif combon == 2:
			anim.play("dfswordswing3")
			dBounce = true
			timer.start()
			while anim.is_playing():
				await get_tree().process_frame
				ply.velocity = lerp(ply.velocity, ply.velocity * Vector3(0.1, 0.1, 0.7), 0.08)
				react()
			ply.switchOnTask(false)
			oncool = true
			combon = 0
			await get_tree().create_timer(cooldown).timeout
			# after logic here	
			print("unfire")
			oncool = false

func react():
	for current in hit_box.get_overlapping_bodies():
		if current.is_in_group("entity") or current.is_in_group("player"):
			if current != ply:
				print(ply)
				print(current)
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
	
