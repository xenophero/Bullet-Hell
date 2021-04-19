extends Control

onready var health_bar = $CanvasLayer/HealthBarOver
onready var health_under = $CanvasLayer/HealthBarUnder
onready var update_tween = $CanvasLayer/UpdateTween
onready var pulse_tween = $CanvasLayer/PulseTween
onready var flash_tween = $CanvasLayer/FlashTween

const FLASH_RATE = 0.05
const N_FLASHES = 4

export (Color) var healthy_color = Color.green
export (Color) var caution_color = Color.yellow
export (Color) var danger_color = Color.red
export (Color) var pulse_color = Color.darkred
export (Color) var flash_color = Color.orangered
export (float, 0, 1, 0.05) var caution_zone = 0.5
export (float, 0, 1, 0.05) var danger_zone = 0.2 
export (bool) var will_pulse = true



signal pulse()

func _on_Player_health_updated(hp):
	print("update health")
	$CanvasLayer/HealthBarOver.value = hp
	$CanvasLayer/UpdateTween.interpolate_property($CanvasLayer/HealthBarUnder, "value", $CanvasLayer/HealthBarUnder.value, hp, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.4)
	$CanvasLayer/UpdateTween.start()
	
	assign_color(hp)
	if hp < 20:
		flash_damage()
	
func assign_color(hp):
	if hp == 0:
		$CanvasLayer/PulseTween.set_active(false)
	elif hp < $CanvasLayer/HealthBarOver.max_value * danger_zone:
		if will_pulse:
			if !$CanvasLayer/PulseTween.is_active():
				$CanvasLayer/PulseTween.interpolate_property($CanvasLayer/HealthBarOver, "tint_progress", pulse_color, danger_color, 1.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
				$CanvasLayer/PulseTween.interpolate_callback(self, 0.0, "emit_signal", "pulse")
				$CanvasLayer/PulseTween.start()
	else:
		$CanvasLayer/HealthBarOver.tint_progress = danger_color
		if hp < $CanvasLayer/HealthBarOver.max_value * caution_zone:
			$CanvasLayer/HealthBarOver.tint_progress = caution_color
		else:
			$CanvasLayer/PulseTween.set_active(false)
			$CanvasLayer/HealthBarOver.tint_progress = healthy_color

	
func _on_Player_max_health_updated(max_health):
	print("max health set")
	$CanvasLayer/HealthBarOver.max_value = max_health
	$CanvasLayer/HealthBarOver.max_value = max_health
	
func flash_damage():
	for i in range (N_FLASHES * 2):
		var color = $CanvasLayer/HealthBarOver.tint_progress if i % 2 == 1 else flash_color
		var time = FLASH_RATE * 1 + FLASH_RATE
		$CanvasLayer/FlashTween.interpolate_callback($CanvasLayer/HealthBarOver, time, "set", "tint_progress", color)
	$CanvasLayer/FlashTween.start()
	print("flash")




