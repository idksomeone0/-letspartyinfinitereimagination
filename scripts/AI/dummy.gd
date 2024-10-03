extends CharacterBody3D

#Generic ahh dummy for my domestic abuse
# By risdorc / ignestr

const SPEED = 5.0
const JUMP_VELOCITY = 4.5


@onready var inventory = $inventory
@onready var navagent = $NavigationAgent3D
@onready var ray = $RayCast3D
@onready var plyman = $"../plyman"

var noise = FastNoiseLite.new()
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Basic entity stuff like the health, spawns array for later on, username, reputation, whatever
var health = 1000
var spawns = []
var username = "Dummy"
var rep = 694200
var P_TYPE = -1
var IS_GOD = false
var age = 9999999
var turbidity = 0
var dead
var lastHit
var itemIndex = 0
var itemReady = false
var onTask = false

enum states {IDLE, MELEING, SHOOT}
enum types {MELEE, RANGED}

var stateMachine = states.MELEING

func gInfo():
	var info = {
	"username" = username,
	"rep" = rep,
	"type" = P_TYPE,
	"exploiter" = IS_GOD,
	"age" = age,
	"aggro" = turbidity,
	"color" = Color(255, 255, 255)
	}
	return info

#Get and Set health
func gHealth():
	return health
func sHealth(new):
	health = new

func doHealth() :
	if health <= 0 and !dead:
		dead = true
		visible = false
		velocity = Vector3.ZERO
		axis_lock_linear_x = true
		axis_lock_linear_y = true
		axis_lock_linear_z = true 
		if lastHit:
			plyman.deathNotif("Dummy", lastHit.gInfo().username)
		else:
			plyman.deathNotif("Dummy", "something")
		for h in inventory.get_children():
			h.queue_free()
		await get_tree().create_timer(2).timeout
		for n in get_parent().get_children():
			if n.is_in_group("spawn"):
				spawns.append(n)
		
		position = Vector3(spawns.pick_random().global_position.x, spawns.pick_random().global_position.y + 3, spawns.pick_random().global_position.z)
		visible = true
		health = 1000
		axis_lock_linear_x = false
		axis_lock_linear_y = false
		axis_lock_linear_z = false 
		dead = false
		


func _process(delta):
	#death
	doHealth()
	if itemReady == true and onTask == false:
		print("hitting")
		inventory.get_node("activeSlot").isPlayer = false
		inventory.get_node("activeSlot").hit()
	

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()
	

func _ready():
	
	
	if stateMachine == states.IDLE:
		pass
	
	elif stateMachine == states.MELEING:
		print("yea")
		if !inventory.get_children().any(func(node): return node.name == 'activeSlot'):
			for n in inventory.get_children():
				itemIndex += 1
				if n.weaponType == types.MELEE:
					print("this happened")
					inventory.act(itemIndex)
					itemReady = true
					break
					
			

func switchOnTask(v):
	onTask = v
