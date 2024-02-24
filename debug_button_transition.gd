extends Button


func _on_pressed():
	CutsceneHandler.play_transition('FadeOut', {'color': Color(.5, .5, .5)})
	await get_tree().create_timer(1).timeout
	CutsceneHandler.play_transition('FadeIn', {'duration': 3})
