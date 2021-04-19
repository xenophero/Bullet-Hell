extends Node2D

export var lifetime = 1
export (float) var speed = 200
export (Vector2) var velocity = Vector2()
export (bool) var use_velocity # if true use velocity if false use rotation
export (float) var rotation_change
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	print("Timer Start")



func _process(delta):
	position += transform.x * speed * delta
	



func _on_Timer_timeout():
	queue_free()
	print("Delete Bullet")
	


func _on_Bullet_body_entered(body):
		body.take_damage()
