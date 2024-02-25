extends Button


func _on_pressed():
	if (text == 'Fade Transition Test'):
		CutsceneHandler.play_transition('FadeOut')
		await get_tree().create_timer(1).timeout
		CutsceneHandler.play_transition('FadeIn')

	if (text == 'Swipe Transition Test'):
		CutsceneHandler.play_transition('SwipeOut')
		await get_tree().create_timer(1).timeout
		CutsceneHandler.play_transition('SwipeIn')
