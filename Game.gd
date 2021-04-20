extends Node2D

var level1clear = false
var level2clear = false
var level3clear = false
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
	if level1clear:
		get_tree().change_scene("res://Levels/Level2.tscn")
	if level2clear:
		get_tree().change_scene("res://Levels/Level3.tscn")
	if level3clear:
		get_tree().change_scene("res://Win.tscn")

func _on_Boss_ClearLevel():
	print("Clear Level")
	$Clear/Label.visible
	$Clear/Button.visible


func _on_Level1Check_level1():
	level1clear = true


func _on_Level2Check_level2():
	level2clear = true
	level1clear = false
	level3clear = false

func _on_Level3Check_level3():
	level3clear = true
	level1clear = false
	level2clear = false
