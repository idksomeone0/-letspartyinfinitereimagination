extends Node3D


var peer = ENetMultiplayerPeer.new()
@export var playerscn : PackedScene
@export var http : AwaitableHTTPRequest



func _ready():
	peer.create_server(135, 10)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()



func _add_player(id = 1):
	var player = playerscn.instantiate()
	player.name = str(id)
	call_deferred("add_child",player)



func _process(delta):
	#if is_multiplayer_authority():
	#	if Input.is_action_just_pressed("joinlocalhost"):
	#		peer.create_client("localhost", 135)
	#		multiplayer.multiplayer_peer = peer
	#		
	#		
	#	if Input.is_action_just_pressed("hostlocal"):
	#		pass
	pass
