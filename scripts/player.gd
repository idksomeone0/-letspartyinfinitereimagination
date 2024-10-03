extends CharacterBody3D

var SPEED = 6.5
var JUMP_VELOCITY = 7
var SENSITIVITY = 0.003
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var plist = $CanvasLayer/Control3/Panel/MarginContainer/GridContainer
@onready var health_bar = $CanvasLayer/Control3/Panel/Panel/MarginContainer/ProgressBar
@onready var usertext = $CanvasLayer/Control3/Panel/Panel/MarginContainer/Panel/MarginContainer/username
@onready var vhead = $Head/fhead
@onready var lefthand = $lefthand
@onready var righthand = $righthand
@onready var fbody = $fbody
@onready var invslots = $CanvasLayer/Control/HBoxContainer
@onready var canvas_layer = $CanvasLayer
@onready var leftray = $left
@onready var rightray = $right
@onready var forwardray = $forward
@onready var timer = $Timer



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var exMovCool = false
var pov = true
var mouseLock = true
var health = 1000
var spawns = []
#    | Most important variable in the entire game
#    V It's there to easily stop most player input when needed for something, and sometimes to debounce
var onTask = false
var username = "hihi"
var pause = false
var rep = 1
var dead
var mouseOnTask
var skinColor 
var flying = false
var defMat
var lastHit
var maneuvering = false
var extendedMovementAllowed = true
var timeCounter = 0
var maneuverActionType = 0

#source vars
var wishdir := Vector3.ZERO 
const headbob_amt = 0.06
const headbob_freq = 2.4
var headbob_tim := 0.0
var auto_bhop = true
@export var air_cap := 0.85
@export var air_accel := 800.0
@export var air_move_speed := 500.0
@export var ground_accel := 14.0
@export var ground_decel := 10.0
@export var ground_friction := 6.0


@onready var invMan = get_node("Hotbar")
@onready var plyman = $"../plyman"


const pi = 3.141592

func toggleLock(tf):
	mouseLock = tf



func gInfo():
	var info = {
	"username" = username,
	"rep" = rep,
	"id" = name,
	"color" = skinColor
	}
	return info
	
func _ready():
	if pov == false:
		var tween = create_tween();
		tween.tween_property(camera, "position", Vector3(1, 0, 3.6), 0.1)
		vhead.visible = true
		#camera.position = camera.position.lerp(Vector3(1, 0, 3.6), 0.5)
	else:
		var tween = create_tween();
		tween.tween_property(camera, "position", Vector3.ZERO, 0.1)
		vhead.visible = false
		#camera.position = camera.position.lerp(Vector3.ZERO, 0.5)
	if get_meta("id"):
		set_multiplayer_authority(get_meta("id"))
	else:
		set_multiplayer_authority(name.to_int())
	if ResourceLoader.load("user://savedata.tres") != null:
		if ResourceLoader.load("user://savedata.tres").username and ResourceLoader.load("user://savedata.tres").skin_color:
			username = ResourceLoader.load("user://savedata.tres").username
			skinColor = ResourceLoader.load("user://savedata.tres").skin_color
	else:
		username = "MyMan"
		skinColor = Color(255, 0, 255)
		push_warning("failed to get username")
	var newMat = StandardMaterial3D.new()
	newMat.albedo_color = skinColor
	newMat.roughness = 1
	righthand.set_surface_override_material(0, newMat)
	fbody.set_surface_override_material(0, newMat)
	lefthand.set_surface_override_material(0, newMat)
	vhead.set_surface_override_material(1, newMat)
	defMat = fbody.get_surface_override_material(0)
	
func gHealth():
	return health

func switchOnTask(v):
	onTask = v

func sHealth(new):
	health = new

func is_surface_too_steep(normal):
	return normal.angle_to(Vector3.UP) > floor_max_angle

func _run_body_test_motion(from, motion, result = null):
	if not result: result = PhysicsTestMotionResult3D.new()
	var params = PhysicsTestMotionParameters3D.new()
	params.from = from
	params.motion = motion
	return PhysicsServer3D.body_test_motion(self.get_rid(), params, result)
func damage(dmg):
	health -= dmg

var rot_x = 0
var rot_y = 0

func _process(delta):
	
	if health <= 0 and !dead:
		for n in get_node("Hotbar").get_children():
			n.queue_free()
		
		for n in invslots.get_children():
			n.queue_free()
		dead = true
		visible = false
		velocity = Vector3.ZERO
		axis_lock_linear_x = true
		axis_lock_linear_y = true
		axis_lock_linear_z = true 
		if lastHit:
			plyman.deathNotif(username, lastHit.gInfo().username)
		else:
			plyman.deathNotif(username, "something")
		await get_tree().create_timer(2).timeout
		for n in get_parent().get_children():
			if n.is_in_group("spawn"):
				spawns.append(n)
		var headstart = invItem.new()
		headstart.name = "fly"
		headstart.itemName = "Flying Power"
		invMan.add_child(headstart)
		position = Vector3(spawns.pick_random().global_position.x, spawns.pick_random().global_position.y + 3, spawns.pick_random().global_position.z)
		visible = true
		health = 1000
		axis_lock_linear_x = false
		axis_lock_linear_y = false
		axis_lock_linear_z = false 
		dead = false
		onTask = false
		invMan.previous = null
		invMan.onTask = false

		
		invMan.updateInv()
		
		
		
	
	if Input.is_action_just_pressed("k") and not onTask:
		health = 0
	
	health_bar.value = health
	usertext.text = username
	if is_multiplayer_authority():
		if mouseLock == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if mouseLock == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
	for o in plist.get_children():
				o.queue_free()
	for h in get_parent().get_children():
		
		if h.is_in_group("player"):
			var plyid = load("res://scenes/ui/playerID.tscn").instantiate()
			plist.add_child(plyid)
			plyid.get_node("user").text = h.gInfo().username
			plyid.get_node("repp").get_node("rept").text = str(h.gInfo().rep)
			plyid.name = h.name

func _input(event):
	if is_multiplayer_authority():
		if event is InputEventMouseMotion and mouseLock == true and not mouseOnTask:
			# modify accumulated mouse rotation
			rot_x += -event.relative.x * SENSITIVITY
			rot_y += -event.relative.y * SENSITIVITY
			
			rot_y = clamp(rot_y, deg_to_rad(-90), deg_to_rad(110))
			transform.basis = Basis()
			head.transform.basis = Basis() # reset rotation
			rotate_object_local(Vector3(0, 1, 0), clamp(rot_x, -90, 90)) # first rotate in Y
			head.rotate_object_local(Vector3(1, 0, 0), clamp(rot_y, -90, 90)) # then rotate in X
			
		if Input.is_action_just_pressed("pause"):
			if pause == false:
				pause = true
				onTask = true
				mouseOnTask = true
				mouseLock = false
				get_node("CanvasLayer/Control2/Chat").visible = false
				get_node("CanvasLayer/Control2/pause").visible = true
			elif pause == true:
				pause = false
				onTask = false
				mouseOnTask = false
				mouseLock = true
				get_node("CanvasLayer/Control2/Chat").visible = true
				get_node("CanvasLayer/Control2/pause").visible = false

	if Input.is_action_just_pressed("switchview") and not onTask:
			if pov == false:
				pov = true
				print("povtrue")
			elif pov == true:
				print("povfalse")
				pov = false
			if pov == false:
				var tween = create_tween();
				tween.tween_property(camera, "position", Vector3(1, 0, 3.6), 0.1)
				vhead.visible = true
				#camera.position = camera.position.lerp(Vector3(1, 0, 3.6), 0.5)
			else:
				var tween = create_tween();
				tween.tween_property(camera, "position", Vector3.ZERO, 0.1)
				vhead.visible = false
				#camera.position = camera.position.lerp(Vector3.ZERO, 0.5)
func headbob(delta):
	headbob_tim += delta * velocity.length()
	camera.transform.origin = Vector3(
	cos(headbob_tim * headbob_freq * 0.5) * headbob_amt,
	sin(headbob_tim * headbob_freq) * headbob_amt,
	0
	)
	
	
func _physics_process(delta):
	if is_multiplayer_authority():
		if flying and not onTask:
			motion_mode = MOTION_MODE_FLOATING
			var camera = get_viewport().get_camera_3d()
			var camera_basis = camera.global_transform.basis
			
			var move_input = Input.get_vector("moveleft", "moveright", "movefwrd", "moveback")
			if not move_input.is_zero_approx():
				velocity = Vector3() # reset velocity as below will process it further
				velocity += move_input.y * camera_basis.z * SPEED
				velocity += move_input.x * camera_basis.x * SPEED
			else:
				velocity = Vector3()
		else:
			motion_mode = MOTION_MODE_GROUNDED
		if Input.is_action_just_pressed("removeLock") and not onTask:
			mouseLock = not mouseLock
		
		# Thanks Maijikayo Games for the source like character tut
		if not onTask and not maneuvering:
			var input_dir = Input.get_vector("moveleft", "moveright", "movefwrd", "moveback").normalized()
			wishdir = global_transform.basis * Vector3(input_dir.x, 0, input_dir.y) 
		if not onTask:
			if not flying:
				if Input.is_action_just_pressed("jump") or auto_bhop and Input.is_action_pressed("jump"):
					# "Every jump, every obstacle, every line of code is a step closer to parkour perfection."
					# motivational quote for the beast of a system I am about to make
					if rightray.is_colliding() and not maneuvering and not onTask and velocity.length() > 5 and not exMovCool and extendedMovementAllowed == true:
						maneuvering = true
						onTask = true
						exMovCool = true
						maneuverActionType = 0
						velocity.y = 0
						print("this happened")
						var tween = create_tween();
						tween.tween_property(camera, "rotation_degrees", Vector3(0, 0, 10), 0.1)
						timeCounter = 0
						while timeCounter < 1.5:
							await get_tree().physics_frame
							timeCounter += delta
							if rightray.is_colliding() != !false:
								break
							var dir = rightray.get_collision_normal()
							velocity = dir.rotated(Vector3.UP, -90) * SPEED
							if Input.is_action_just_pressed("jump"):
								velocity += dir * SPEED /1.5
								velocity += dir * basis
								velocity.y += JUMP_VELOCITY
								break
						print("it's joever")
						maneuvering = false
						onTask = false
						timeCounter = 0
						tween = create_tween();
						tween.tween_property(camera, "rotation_degrees", Vector3(0, 0, 0), 0.1)
						await get_tree().create_timer(0.5).timeout
						exMovCool = false
					if leftray.is_colliding() and not maneuvering and not onTask and velocity.length() > 5 and not exMovCool and extendedMovementAllowed == true:
						maneuvering = true
						onTask = true
						exMovCool = true
						maneuverActionType = 0
						velocity.y = 0
						print("this happened")
						var tween = create_tween();
						tween.tween_property(camera, "rotation_degrees", Vector3(0, 0, -10), 0.1)
						timeCounter = 0
						while timeCounter < 1.5:
							await get_tree().physics_frame
							timeCounter += delta
							if leftray.is_colliding() != !false:
								break
							var dir = leftray.get_collision_normal()
							velocity = dir.rotated(Vector3.UP, 90) * SPEED
							if Input.is_action_just_pressed("jump"):
								velocity += dir * SPEED /1.5
								velocity += dir * basis
								velocity.y += JUMP_VELOCITY
								break
						print("it's joever")
						maneuvering = false
						onTask = false
						timeCounter = 0
						tween = create_tween();
						tween.tween_property(camera, "rotation_degrees", Vector3(0, 0, 0), 0.1)
						await get_tree().create_timer(0.5).timeout
						exMovCool = false
					if is_on_floor():
						velocity.y = JUMP_VELOCITY
		
	if is_on_floor() and not flying and not maneuvering:
		groundPhys(delta)
	elif not flying and not maneuvering:
		airPhys(delta)
	move_and_slide()

func airPhys(delta):
	velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta
	#none of this is mine I copied it from a tutorial
	#coming off clean
	var cur_speed_in_wish_dir = velocity.dot(wishdir)
	var capped_speed = min((air_move_speed * wishdir).length(), air_cap)
	var add_speed_till_cap = capped_speed - cur_speed_in_wish_dir
	if add_speed_till_cap > 0:
		var accel_speed = air_accel * air_move_speed * delta
		accel_speed = min(accel_speed, add_speed_till_cap)
		velocity += accel_speed * wishdir
	
	
	
func groundPhys(delta):
	var cur_speed_in_wish_dir = velocity.dot(wishdir)
	var add_speed_till_cap = SPEED - cur_speed_in_wish_dir
	if add_speed_till_cap > 0:
		var accel_speed = ground_accel * delta * SPEED
		accel_speed = min(accel_speed, add_speed_till_cap)
		velocity += accel_speed * wishdir
	
	var control = max(velocity.length(), ground_decel)
	var drop = control * ground_friction * delta
	var new_speed = max(velocity.length() - drop, 0.0)
	if velocity.length() > 0:
		new_speed /= velocity.length()
	velocity *= new_speed
	
	if pov == true:
		headbob(delta)


func _on_text_edit_focus_entered():
	onTask = true
	mouseOnTask = true


func _on_text_edit_focus_exited():
	onTask = false
	mouseOnTask = false


func _on_hotbar_child_exiting_tree(node):
	self.get_node("lefthand").visible = true
	self.get_node("righthand").visible = true
	fbody.set_surface_override_material(0, defMat)
	flying = false
	SPEED = 6.5
