extends Node3D


@onready var hit_box = $RigidBody3D/hitbox
@onready var phys = $RigidBody3D
@onready var ply = $"../../../"


var vdamage = 50
# Called when the node enters the scene tree for the first time.


func damage(emt, dmh):
	emt.sHealth(emt.gHealth() - dmh)
	emt.lastHit = ply
	
	

func _on_rigid_body_3d_body_entered(body):
	queue_free()
	


func _physics_process(delta):
	print(ply)
	phys.linear_velocity = -Vector3(0, 0, 1).rotated(Vector3(0, 1, 0), ply.rotation.y) * 100
	
	for current in hit_box.get_overlapping_bodies():
		if current.is_in_group("entity") or current.is_in_group("player") and current.name != ply.name:
				damage(current, vdamage)
				queue_free()


func _ready():
		await get_tree().create_timer(5).timeout
		queue_free()
