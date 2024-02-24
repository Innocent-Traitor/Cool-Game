extends Node
class_name Cutscene_Handler

const DEFAULTS = {
	'fade': {
		'duration': 1,
		'color': Color(0, 0, 0)
	}
}

## Plays Transitions, First Argument is Transition Type, second is a dictionary containing the options for cutscene customization (OPTIONAL)
## FadeOut | FadeIn - Fade the Screen a single color for a set duration
##   duration : int - Duration in seconds for the fade to complete (Default: 1)
##   color : color - Color of the fade (Default: Color(0, 0, 0))
func play_transition(type : String, options : Dictionary = {}) -> void:
	match (type):
		'FadeOut':
			fade_out_transition(options)
		'FadeIn':
			fade_in_transition(options)
		_:
			return


func fade_out_transition(options):
	print('fade out')
	if (not len(options) == 2): 
		options.duration = DEFAULTS.fade.duration if not options.has('duration') else options.duration
		options.color = DEFAULTS.fade.color if not options.has('color') else options.color

	var obj = ColorRect.new()
	obj.size = Vector2(1152, 648)
	obj.position = Vector2(0, 0)
	obj.color = options.color
	obj.modulate.a = 0
	obj.z_index = 99
	add_child(obj)

	var tween = create_tween()
	tween.tween_property(obj, 'modulate:a', 1, options.duration)
	tween.tween_callback(obj.queue_free)


func fade_in_transition(options):
	print('fade in')
	if (not len(options) == 2):
		options.duration = DEFAULTS.fade.duration if not options.has('duration') else options.duration
		options.color = DEFAULTS.fade.color if not options.has('color') else options.color

	var obj = ColorRect.new()
	obj.size = Vector2(1152, 648)
	obj.position = Vector2(0, 0)
	obj.color = options.color
	obj.modulate.a = 1
	obj.z_index = 99
	add_child(obj)

	var tween = create_tween()
	tween.tween_property(obj, 'modulate:a', 0, options.duration)
	tween.tween_callback(obj.queue_free)
