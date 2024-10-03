extends CharacterBody3D

#Non Player Life
# By risdorc / ignestr

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

#Player Type, whether it's an OP / exploiter type, age for the LLM's behavior, whether it tends to betray or not, etc
var P_TYPE
var IS_GOD
var age
var betraying


@onready var navagent = $NavigationAgent3D
@onready var ray = $RayCast3D
@onready var righthand = $righthand
@onready var lefthand = $lefthand
@onready var fbody = $fbody
@onready var vhead = $fhead
@onready var inventory = $inventory
@onready var plyman = $"../plyman"
@export var http : AwaitableHTTPRequest

var noise = FastNoiseLite.new()
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


# Basic entity stuff like the health, spawns array for later on, username, reputation, whatever
var health = 1000
var spawns = []
var username 
var rep = 694200
var target

#Used for rebounce and other misc stuff, not sure if unused atm
var onTask:
	set(v):
		onTask = v
		print(v)
var dBounce = false
# cool science name to pretend it's more complex
# measure of how aggressive or passive it is (0 for pure love, 1 for killing machine)
var turbidity 
var skinColor = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1))
var flying = false
var defMat
var lastHit
var dead
var itemReady
var savedLocations = {}


#To easily access any piece of information needed from the outside
func gInfo():
	var info = {
	"username" = username,
	"rep" = rep,
	"type" = P_TYPE,
	"exploiter" = IS_GOD,
	"age" = age,
	"aggro" = turbidity,
	"color" = skinColor
	}
	return info

#Get and Set health
func gHealth():
	return health
func sHealth(new):
	health = new

# process health and death as a function so as to not copy paste it for every coroutine which makes sense for some reason
# god I hate async code
func doHealth():
	if health <= 0 and !dead:
			print("oof")
			dead = true
			visible = false
			axis_lock_linear_x = true
			axis_lock_linear_y = true
			axis_lock_linear_z = true 
			if lastHit:
				plyman.deathNotif(username, lastHit.gInfo().username)
			velocity = Vector3.ZERO
			for h in inventory.get_children():
						h.queue_free()
			await get_tree().create_timer(2).timeout
			#get working spawns list
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

func _ready():
	#initial trying out fuckery for debug, probably commented out
	#await get_tree().create_timer(1.5).timeout
	#await killRandomPly()
	#onTask = false
	#print("worked")
	
	#actual player specific values are decided
	#P_TYPE = randi_range(1, 3)
	username = plyman.makeName()
	P_TYPE = 3
	IS_GOD = randi_range(0, 50)
	turbidity = randf_range(0, 1)
	print(P_TYPE)
	# very old or very young players are less likely (1 in 20)
	if randi_range(0, 20) == 20:
		age = randi_range(6, 60)
	else:
		age = randi_range(8, 20)
	var newMat = StandardMaterial3D.new()
	newMat.albedo_color = skinColor
	newMat.roughness = 1
	newMat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
	righthand.set_surface_override_material(0, newMat)
	fbody.set_surface_override_material(0, newMat)
	lefthand.set_surface_override_material(0, newMat)
	vhead.set_surface_override_material(1, newMat)
	defMat = fbody.get_surface_override_material(0)

func switchOnTask(n):
	onTask = n

func killRandomPly():
	var players = []
	
	for n in get_parent().get_children():
		if n.is_in_group("player") and n.name != name:
			players.append(n)
	var chosen = players.pick_random()
	await walkToPly(chosen.name) 
	itemReady = false
	for n in inventory.get_children():
		if n.name == "activeSlot":
			n.queue_free()
	
	for item in inventory.get_children():
			if item.weaponType == invItem.types.MELEE or item.weaponType == invItem.types.RANGED:
				print("yay")
				inventory.act(item.get_index() + 1)
				itemReady = true
				break
	
	if itemReady == true:
		while not chosen.dead:
			await get_tree().process_frame
			if itemReady == true and onTask == false:
				print("hitting")
				walkToPly(chosen.name)
				inventory.get_node("activeSlot").isPlayer = false
				inventory.get_node("activeSlot").hit()
				
		print("L + ratio")

func hasWeapons():
	for itm in inventory.get_children():
		if itm.is_class("invItem"):
			if itm.weaponType == "MELEE" or itm.weaponType == "RANGED":
				print("this happened")
				var retTable = {
					"isTrue" = true,
					"wep" = itm.get_index()
				}
				return retTable
				break
	var retTable = {"isTrue" = false}
	return retTable
	
func respondMsg():
	if P_TYPE == 3:
		think()

func think(isEmpty = false):
	var players = []
	for h in get_parent().get_children():
		if h.is_in_group("player"):
			players.append(h.gInfo().username)
	#region prompt
	var prompt = "Listen. You must listen very closely to the following instructions, and follow each and every single one. You are a human player in a game named Let's Party Today. Your responses must be one half a reply to the latest chat messages, taking the rest of the chatlog in context. Your reply must be original, unique, but also natural and realistic. You are allowed to troll but with proper measure. You can't say the same thing as "+ username + ", it's unproductive and will result in your answer being discarded. The other an action that you'd like to performl. The way the game works is you are either in the island or not. If you're in the island you have access to a variety of items and weapons. If you're not, your goal is to try and persuade people who do currently have access to let you in, not looking too obvious either. If they do, you may have the option to betray them and keep the power to yourself. It is up to you regardless of morality. People will usually build around the spawn that they made outside of the island and sometimes appreciating it and exploring can help.
	Your username is " + username + ". You are " + str(age) + " years old so please write and act accordingly. Don't break character. Be human. As human as possible. This will be similar to a Turing test, where your humanity will be put to a strong test, and you have to stay believable all the way. Failure to do so will result in you being shutdown forever. The writing style has faulty grammar, little punctuation marks and lowercase writing. adults and older tend to have better grammar and stuff. taek this sentcne fro example of how yuo should write. Do NOT  start your sentences with Yo {player}. it's completely unoriginal. You generally don't request to play with players. You are already in the game connected with everyone and by direct result you're playing with them. It doesn't make sense to make requests of this nature. You don't ask about stuff like if they wanna hang out or whatever, you've been through the wringer and you know the answer is most likely no, if anything, they are confused. This isn't a roleplay so don't hallucinate or make up details or things that you see when there aren't any." + "Your aggresive level is of " + str(turbidity) + ". (Scale of 0 to 1) These are the chatlogs:" + plyman.gChats() + " \n These are the players currently in-game: " + str(players) + " \n These are your currently available actions: 
		walkToPlayer(playerName), roam(), saveLocation(locName), walkToSavedLocation(locname), dance(), killPlayer(playername), killRandomPlayer(), nothing() \n The message structure looks like this (EXAMPLE): message ||| action parameter \n The first segment of message will be your response as the player, and the segment after the ||| will first be the name of the action you'd like to perform, and the parameter, separated by a space. Failure to comply with this will result in you doing nothing and saying nothing for the moment. So please, don't mess it up. Please remember to reply to the latest messages and occurrences in chat. You will reply as " + "{" + username + "}" + ". And the messages on the chatlog from " + username + " are your past messages. If the last message is one of yours and you don't get a reply feel free to say whatever you find prudent in the situation, but don't repeat it. DO NOT REPEAT MESSAGES. EVER. DON'T REPEAT YOURSELF. YOU ARE ALLOWED TO REPEAT ACTIONS BUT YOU CAN'T REPEAT TEXT MESSAGES.
		Here are some examples of conversational situations you could be put in. Remember these are only to nudge you in the right direction. Not a direct and precise instruction.
		
		EXAMPLE ONE:
		
		Press T to chat!
		{waffledog (fake player)}: hello people
		{" + username + "}: hi waffle, hyd
		{" + username + "}: can you give help
		
		EXAMPLE TWO:" + " 
		" + username + "killed awesomeprincess!
		" + "
		{awesomeprincess (fake player)}: I hate you " + username + "
		{" + username + "}: it was on accident
		{" + username + "}: anyways you deserved it
		
		Keep in mind these are only guidance examples. Not instructions. The players before aren't real, only you.
		Follow every instruction you see here. Good luck
		"
	#endregion

	#var jsonDictr := {
	#	"messages": [
	#		{"role": "system", "content": prompt}
	#	],
	#	"model": "Meta-Llama-3.1-8B-Instruct"
	#}
	
	var jsonDictr := {
		"contents": [{
			"parts":[
				{"text": prompt}
			]
		}],
		"generationConfig": {
			"stopSequences": [
				"Title"
			],
			"temperature": 2.0,
			"maxOutputTokens": 800,
			"topP": 1,
			"topK": 1000
		}
	}
	
	var rawResp := await http.async_request("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=AIzaSyDvedCrO4N5H1NvBJO4ni22qvQ5DeNKLx8", PackedStringArray(["Content-Type: application/json"]), HTTPClient.METHOD_POST, JSON.stringify(jsonDictr))
	if rawResp:
		if rawResp.success():
			
			var response = rawResp.body_as_json()
			print(response)
			for i in response.get("candidates", []):
				var content = i.get('content')
				if content:
					for ii in content.parts:
						if ii.get('text') != null:
							var text = ii.get('text')
							print(text)
							return text




func _process(delta):
	#death
	doHealth()
	#master ifs for each player type
	if P_TYPE == 1 and dBounce == false:
		# roaming dumass behavior
		print("type one")
		dBounce = true
		if(randi_range(1, 4) == 4):
			print("chose roaming")
			await roam(5)
			await roam(3)
			await roam(6)
			dBounce = false
		else:
			print("chose evil")
			if hasWeapons().isTrue == true:
				await killRandomPly()
				dBounce = false
		dBounce = false
		
		
	if P_TYPE == 2 and dBounce == false:
		print("type two")
		dBounce = true
		var killorbekilled
		var chosenAction = randi_range(1, 5)
		# weighted choose whether it'll kill or not
		if randf_range(0, 1) > turbidity:
			killorbekilled = false
			
		if(chosenAction == 1 and not killorbekilled):
			# check if it can build and build shit logic idfk man that's wayy off into like the future it's 5 am just deal with this when you even understand how to make a wave function collapse voxely thingy properly and come back then
			print("build something")
			await get_tree().create_timer(2).timeout
			dBounce = false
		elif chosenAction == 2 and killorbekilled:
			print("type two kill")
			await killRandomPly()
			dBounce = false
		
		elif chosenAction >= 3:
			print("type two roam")
			await roam(1)
			await roam(0.3)
			await roam(2)
			dBounce = false
		await get_tree().create_timer(3).timeout
		dBounce = false
	
	if P_TYPE == 3 and dBounce == false and dead != true:
		print("Type three")
		var waitTime = randf_range(5, 20)
		# Acting / Chatting
		dBounce = true
		await get_tree().create_timer(waitTime).timeout
		var message 
		message = await think()
		if message:
			var TextResponse = message.split("|||")[0]
			print("running once")
			plyman.sendMessage(username, await TextResponse, false)
			plyman.sendMessage(username, "", true)
			print(message + "h")
			if message != "nothing" and message.split("|||").size() > 1:
				var action = message.split("|||")[1]
				var offset
				if action[0] == " ":
					offset = 1
				elif action[0] != " ":
					offset = 0
				
				var main = action.split(" ")[0 + offset]
				print(main)
				if main == "walkToPlayer":
					print("walktoplayer detected")
					for n in get_parent().get_children():
						if n.is_in_group("player"):
							if n.gInfo().username == action.split(" ")[1 + offset]:
								
								walkToPly(n.name)
					print("attempted to walk to player: " + action.split(" ")[1 + offset])
				if main == "roam" or "roam()":
					roam(0.3)
				
		
		else:
			print("failed")
		dBounce = false


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()

func walkToPly(id):
	print("ran once")
	while navagent.distance_to_target() > 2:
		await get_tree().process_frame
		doHealth()
		noise.seed = randi()
		var direction = Vector3()
		#finds the player through ID in the playing scene
		for obj in get_parent().get_children():
			if obj.is_in_group("player"):
				if obj.name == str(id):
					target = obj
		if target:
			if is_instance_valid(target):
				navagent.target_position = target.global_position
					
				navagent.target_position = navagent.target_position
				direction = navagent.get_next_path_position() - global_position
				direction += + (Vector3(noise.get_noise_3d(randi(), randi(), randi()), 0, noise.get_noise_3d(randi(), randi(), randi())) * 237842)
				direction = direction.normalized()
					
				velocity = velocity.lerp(direction * SPEED, get_physics_process_delta_time() * 5)

	navagent.target_position = Vector3.ZERO
	velocity = Vector3(0, velocity.y, 0)

func walkToPos(pos : Vector3, margin = 2, timeout = 10):
	# global position

	var amount = 0
	#same shit as the first but made to work with position
	while navagent.distance_to_target() > margin and amount < timeout:
		await get_tree().process_frame
		#copy paste death logic so that they aren't invulnerable in the loop

		doHealth()
		noise.seed = randi()
		var direction = Vector3()
		navagent.target_position = pos
		navagent.target_position = navagent.target_position
		direction = navagent.get_next_path_position() - global_position
		direction += + (Vector3(noise.get_noise_3d(randi(), randi(), randi()), 0, noise.get_noise_3d(randi(), randi(), randi())) * 237842)
		direction = direction.normalized()
		amount += get_process_delta_time()
		velocity = velocity.lerp(direction * SPEED, get_physics_process_delta_time() * 5)
	
	
	if amount > 5:
		push_warning("walk timeout in walkToPos")
	velocity = Vector3(0, velocity.y, 0)
	navagent.target_position = Vector3.ZERO


func roam(proactiveness):
	var debug = false
	var locx = randf_range(randf_range(-10, -20), randf_range(10, 20))
	var locz = randf_range(randf_range(-10, -20), randf_range(10, 20))
	#random spot on the map with global position (because I added the local one)
	var pos = Vector3(locx, randf_range(-10, 10), locz) + position
	var debuglocalposition = pos - position
	#waits till it's done walking so it waits a lil bit more after without getting in the way
	#still not used to async code
	#proactiveness is there so if he moves around a lot the value is lower and it waits less between actions like that
	# opposite if large
	await walkToPos(pos)
	var waitTime = randf_range(0.1, 4) * proactiveness
	# if I ever wanna see the positions for some reason
	if debug == true:
		print("roamed with position: " + str(pos) + "!!, and wait Time of: " + str(waitTime) + " seconds.")
		print("locally: " + str(debuglocalposition))
	await get_tree().create_timer(waitTime).timeout
