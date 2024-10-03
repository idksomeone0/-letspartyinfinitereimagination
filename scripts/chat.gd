extends TextEdit

@onready var plyman = get_tree().current_scene.get_child(0).get_node("plyman")
@onready var ply = $"../../../.."
@onready var log = $"../log"

var onTask = false



# Called when the node enters the scene tree for the first time.
func _input(event):
	if Input.is_action_just_pressed("openchat") and not onTask:
		release_focus()
		await get_tree().create_timer(0.01).timeout
		grab_focus()
		
	if Input.is_action_just_pressed("exitChat"):
		release_focus()
	if Input.is_action_just_pressed("sendChat") and onTask:
		release_focus()
		grab_focus()
		release_focus()
		plyman.sendMessage(ply.gInfo().username, text, false)
		plyman.sendMessage("", "", true)
		clear()

func _process(delta):
	log.text = FileAccess.open("user://" + plyman.getTime() + "/chatlog.dat", FileAccess.READ).get_as_text()
	
	

func _on_focus_entered():
	onTask = true



func _on_focus_exited():
	onTask = false
