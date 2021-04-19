extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	$FadeOut.play("FadeOut")
	


func _on_FadeOut_animation_finished(anim_name):
	$AudioStreamPlayer.stop()
	$BossMusic.play()



func _on_Button_pressed():
	pass # Replace with function body.


func _on_Boss_ClearLevel():
	print("Clear Level")
	$Clear/Label.visible
	$Clear/Button.visible
