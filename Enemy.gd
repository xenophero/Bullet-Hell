extends KinematicBody2D

var player = null
export var bullet_scene: PackedScene
onready var shoot_timer = $shootTimer
onready var rotator = $rotator
export var rotate_speed = 100
export var shooter_timer_wait_time = 0.2
export var spawn_point_count = 4
export var radius = 100
export (int) var start_hp : int = 100
onready var hp = start_hp
var can_take_damage = true
export (int) var points = 10
# var a = 2
# var b = "text"
onready var animation_player = $AnimationPlayer

var move = Vector2.ZERO
var moveSpeed = 20

signal tookDamage(value)
signal setMaxHp(value)
signal sendPoints(points)


export (bool) var isBoss = false
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
	emit_signal("setMaxHp", start_hp)

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

		
func take_damage():
	if (can_take_damage):
		hp -= 1
		animation_player.play("Hit")
		emit_signal("tookDamage", hp)
		$AudioStreamPlayer2D.play()
	else:
		return
	


func _on_AnimationPlayer_animation_finished(Hit):
	if hp <1:
		isDead(points)
	else:
		return
		
func isDead(points):
		$DeadFX.play()
		emit_signal("sendPoints", points)
		print(points)
		$DeathTimer.start(0.2)


		
#pathfinding



func _on_EnemySight_body_entered(body):
	if body.name == "Player":
		player = body
	shoot_timer.start()
		


func _on_EnemySight_body_exited(body):
	player = null

func _physics_process(delta):
	move = Vector2.ZERO
	if player != null:
		move = position.direction_to(player.position) * moveSpeed
	else:
		move = Vector2.ZERO
	
	move = move.normalized()
	move = move_and_collide(move)






func _on_DeathTimer_timeout():
	queue_free()
