extends WorldEnvironment
var dayLength = 2 # in minutes
var converted

@onready var clock = $"../CSGBox3D/Label3D"
@onready var sun = $Node3D/DirectionalLight3D
var isNight = false

var timeOfDay = 331 #initial
var daysPassed = 0

func _process(delta):
	if timeOfDay >= 360:
		timeOfDay = 0
		daysPassed += 1
	
	if (timeOfDay >= 0 and timeOfDay <= 89) or timeOfDay >= 271:
		isNight = false
	elif timeOfDay >= 90 and timeOfDay <= 270:
		isNight = true
	
	
	if isNight == false:
		sun.light_energy = 3
	else:
		sun.light_energy = 0
	
	timeOfDay += delta * (360 / (dayLength * 60)) # Convert time based on degrees
	sun.rotation.x = deg_to_rad(timeOfDay)
	converted = timeOfDay / 15
	clock.text = str(isNight)
