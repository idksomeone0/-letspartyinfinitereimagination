extends Node3D


var time = Time.get_datetime_string_from_system().replace(":", "-")
var file
var chatlogs
signal messageSent
signal plyDeath

func getTime():
	return time

func _ready():
	var base = DirAccess.open("user://")
	base.make_dir(time)
	file = FileAccess.open("user://" + time + "/chatlog.dat", FileAccess.WRITE)
	sendMessage("System", "Press T to chat!", false)
	# Send empty message because of a weird quirk where it only updates the message before
	# virtually the same as sending the	 message normally
	sendMessage("", "", true)

func sendMessage(user, message, isEmpty):
	if isEmpty == false:
		file.store_string(file.get_as_text() + "\n" + "{" + user + "}: " + message)
		messageSent.emit()
	if isEmpty == true:
		file.store_string(file.get_as_text())
		
		
func deathNotif(user, killer):
	file.store_string(file.get_as_text() + "\n" + user + " was killed by " + killer + "...")
	sendMessage("", "", true)
	plyDeath.emit()
func gChats():
	var tmpFile = FileAccess.open("user://" + time + "/chatlog.dat", FileAccess.READ)
	sendMessage("", "", true)
	tmpFile = FileAccess.open("user://" + time + "/chatlog.dat", FileAccess.READ)
	return tmpFile.get_as_text()

func makeName():
	var dictionary = ["richard", "robert", "maria", "adolftwinkypie", "sonicthehedgehog", "foxbin", "portaltwoisthebestgameever", "Ilovemymom", "HELPMEHELPME", "the fog is coming", "liberals suck", "minecraftgamerpro6969"]
	return dictionary.pick_random()
