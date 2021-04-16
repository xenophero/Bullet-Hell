extends Node2D


export var bullet_scene: PackedScene
export var min_rotation = 0
export var max_rotation = 360
export var number_of_bullets = 8
export var is_random = false
export var is_parent = false
export var is_manual = false
export var spawn_rate = 0.4
export var bullet_velocity = 10
export var bullet_lifetime = 10
export (bool) var use_velocity = false

var rotation = []
export (bool) var log_to_console
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
