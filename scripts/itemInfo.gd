@icon("res://resources/vector icons/handle-with-care-icon.svg")
extends Node3D
class_name invItem

enum types {MELEE, RANGED}

@export var itemName = " "
@export var itemDef = " "
@export var weaponType : types
