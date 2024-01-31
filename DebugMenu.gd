extends Control


func _process(_delta: float) -> void:
	$FPSCounter.text = 'FPS: ' + str(Engine.get_frames_per_second())
