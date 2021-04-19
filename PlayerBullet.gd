extends Area2D

export (float) var lifetime = 10.00
export  var speed = 200
export (Vector2) var velocity = Vector2()
export (bool) var use_velocity # if true use velocity if false use rotation
export (float) var rotation_change
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(lifetime)



#func _process(delta):
#	if use_velocity:
#		position += velocity.normalized() * speed * delta
#	else:
#		position += Vector2(cos(rotation), - sin(rotation)) * speed * delta
		
#	rotation_degrees += rotation_change * delta

func _process(delta):
	position += transform.x * speed * delta


func _on_Timer_timeout():
	queue_free()
	


func _on_PlayerBullet_body_entered(body):
	body.take_damage()
	print("hit")


func _on_PlayerBullet_area_entered(area):
	area.take_damage()
