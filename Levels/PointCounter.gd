extends Node2D
onready var pointsTotal = 0
onready var clearlabel = get_node("../Clear/Label")
onready var clearbutton = get_node("../Clear/Button")
signal clearTrigger()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Enemy_sendPoints(points):
	pointsTotal += points
	print(pointsTotal)
	$CanvasLayer/pointlabel.set_text(str(pointsTotal))
	if pointsTotal > 1000:
		emit_signal("clearTrigger")
