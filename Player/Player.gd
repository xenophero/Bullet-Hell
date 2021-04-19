extends KinematicBody2D

export (int) var speed = 200
export (int) var start_hp : int = 3
onready var hp = start_hp
var health = hp
export var max_health = 200
var can_take_damage = true
onready var animation_player = $AnimationPlayer

export (bool) var clamp_to_window_borders = true
onready var screen_borders = Vector2(
	ProjectSettings.get_setting("display/window/size/width"),
	ProjectSettings.get_setting("display/window/size/height"))

#Buff Vars
export (bool) var invcincible = false
export (bool) var do_double_damage = false
export (bool) var take_half_damage = false
export (bool) var haste = false
export (bool) var slowed = false
var buff = 0

#Scoring Vars
export (int) var points = 0

#bullet stuff
export var bullet_scene: PackedScene
export var min_rotation = 0
export var max_rotation = 360
export var number_of_bullets = 1
export var is_random = false
export var is_parent = false
export var is_manual = true
export var spawn_rate = 0.4
export var bullet_velocity = 10
export var bullet_lifetime = 10
export var bullet_speed = 5
export (bool) var use_velocity = false
var rotations = []
export (bool) var log_to_console

signal health_updated(health)
signal max_health_updated(max_health)
var healthbar = "../CanvasLayer/HealthBar"

func _ready():
	$Timer.wait_time = spawn_rate
	$Timer.start()
	emit_signal("max_health_updated", max_health)

func _physics_process(delta):
	#input
	var velocity = Vector2()
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	velocity = velocity.normalized()
	
	velocity = move_and_slide(velocity * speed)
	
func _unhandled_input(event):
	if event.is_action_pressed("shoot"):
		spawn_bullets()
		print("Shoot")
		$GunFX.play()
	
#clamp player to screen borders
	if clamp_to_window_borders:
		global_position = Vector2(clamp(global_position.x, 0, screen_borders.x), clamp(global_position.y, 0, screen_borders.y))
		
func take_damage():
	if (can_take_damage):
		can_take_damage = false
		hp -= 1
		animation_player.play("Hit")
		update_health(hp)
		$AudioStreamPlayer2D.play()
	else:
		return
		
func update_health(hp):
	emit_signal("health_updated", hp)
	

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Hit" and buff != 1:
		can_take_damage = true
		if hp == 0:
			get_tree().change_scene("res://GameOver.tscn")
			
			
func random_rotations():
	rotations = []
	for i in range(0, number_of_bullets):
		rotations.append(rand_range(min_rotation, max_rotation))
		
func distributed_rotations():
	rotations = []
	for i in range(0, number_of_bullets):
		var fraction = float(i) /float(number_of_bullets)
		var difference = max_rotation - min_rotation
		rotations.append((fraction * difference) + min_rotation)

func spawn_bullets():
	if (is_random):
		random_rotations()
	else:
		distributed_rotations()
	var spawned_bullets = []
	for i in range(0, number_of_bullets):
		#instancing
		var bullet = bullet_scene.instance()
		
		spawned_bullets.append(bullet)
		
		
		#parenting
		if (is_parent):
			add_child(spawned_bullets[i])
		else:
			get_node("/root").add_child(spawned_bullets[i])
			
		#apply fields
		spawned_bullets[i].rotation_degrees = rotations[i]
		spawned_bullets[i].speed = bullet_speed
		spawned_bullets[i].velocity = bullet_velocity
		spawned_bullets[i].global_position = global_position
		spawned_bullets[i].use_velocity = use_velocity
		spawned_bullets[i].lifetime = bullet_lifetime
		
		if (log_to_console):
			print("bullet" + str(i) + " @ " + str(rotations[i]) + "deg")
			
	return spawned_bullets

func _on_Timer_timeout():
	if !is_manual:
		spawn_bullets()
	if (log_to_console):
		print("Spawned bullets")


func _on_BuffUI_buffChange(buff):
	var orig_speed = 200
	var orig_bullets = 1
	if buff != 1:
		can_take_damage = true
		speed = orig_speed
		number_of_bullets = orig_bullets
	if buff == 1:
		can_take_damage = false
		speed = orig_speed
		number_of_bullets = orig_bullets
	if buff == 2:
		number_of_bullets = number_of_bullets * 2
		speed = orig_speed
	if buff == 3:
		speed = orig_speed * 2
		number_of_bullets = orig_bullets
	if buff == 4:
		speed = orig_speed / 1.5

