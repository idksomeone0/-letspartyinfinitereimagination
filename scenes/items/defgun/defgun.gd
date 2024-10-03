extends Node3D
# Gun
@onready var sw_1 = $res/sw1
@onready var ply = $"../.."
@onready var anim = $AnimationPlayer
@onready var hit_box = $hitBox
@onready var righthand = $righthand
@onready var lefthand = $lefthand
@onready var sw_2 = $res/sw2
const GUNSHOT = preload("res://sound/itemsfx/defgun/gunshot.mp3")

var cooldown = 0.1
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
	sw_2.play()

func _process(delta):
	ply.get_node("righthand").visible = false
	if is_multiplayer_authority():
		if Input.is_action_just_pressed("itemMain") and oncool == false:
			# instant logic here
			oncool = true
			anim.play("shoot")
			var audio = AudioStreamPlayer3D.new()
			audio.stream = GUNSHOT
			audio.autoplay = true
			add_child(audio)
			var bullet = load("res://scenes/items/defgun/bullet.tscn").instantiate()
			add_child(bullet)
			bullet.position = sw_1.position
			await get_tree().create_timer(cooldown).timeout
			# after logic here
			
			print("unfire")
			oncool = false

	


func damage(emt, dmh):
	emt.sHealth(emt.gHealth() - dmh)
	emt.lastHit = ply
func _on_hit_box_body_exited(body):
	current = body
	print("entered")


func _on_timer_timeout():
	combon = 0
	anim.queue("dfswordidle")
	
