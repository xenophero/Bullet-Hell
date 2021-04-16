extends Node2D

export var bullet_scene: PackedScene
onready var shoot_timer = $shootTimer
onready var rotator = $rotator
export var rotate_speed = 100
export var shooter_timer_wait_time = 0.2
export var spawn_point_count = 4
export var radius = 100

# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var step = 2 * PI / spawn_point_count
	
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotator.add_child(spawn_point)

	shoot_timer.wait_time = shooter_timer_wait_time
	shoot_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta: float) -> void:
	var new_rotation = rotator.rotation_degrees + rotate_speed * delta
	rotator.rotation_degrees = fmod(new_rotation, 360)

func _on_shootTimer_timeout():
	for s in rotator.get_children():
		var bullet = bullet_scene.instance()
		get_tree().root.add_child(bullet)
		bullet.position = s.global_position
		bullet.rotation = s.global_rotation
	
