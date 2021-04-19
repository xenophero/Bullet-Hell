extends CanvasLayer

var seconds = 0
var ms = 0

#buff stuff
var buff = 0

signal buffChange(buff)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#Counter
func _process(delta):
	if ms > 9:
		seconds += 1
		ms = 0
	$Panel/Label.set_text(str(seconds))
	if seconds == 10 and ms == 9:
		ms = 0
		seconds = 0
		random_buff_variable()


func _on_CountDown_timeout():
	ms += 1


#buff stuff
func random_buff_variable():
	buff = randi()%4 +1
	emit_signal("buffChange", buff)
	buff_label(buff)
	
func buff_label(buff):
	if buff == 1:
		$Panel/buffText.set_text("invul")
	if buff == 2:
		$Panel/buffText.set_text("DBL")
	if buff == 3:
		$Panel/buffText.set_text("HASTE")
	if buff == 4:
		$Panel/buffText.set_text("SLOW")
	else:
		return
		
