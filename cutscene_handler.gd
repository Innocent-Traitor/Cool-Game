extends Node
class_name Cutscene_Handler

const DEFAULTS = {
	'fade': {
		'duration': 1,
		'color': Color(0, 0, 0)
	},
	'swipe': {
		'duration': 1,
		'color': Color(0, 0, 0),
		'direction': 'left'
	}
}

## Plays Transitions, First Argument is Transition Type, second is a dictionary containing the options for cutscene customization (OPTIONAL)
## FadeOut | FadeIn - Fade the Screen a single color for a set duration
##   duration : int - Duration in seconds for the fade to complete (Default: 1)
##   color : color - Color of the fade (Default: Color(0, 0, 0))
##
## SwipeIn | SwipeOut - Swipes across the screen in a fading color for a set duration
##   duration : int - Duration in seconds for the fade to complete (Default: 1)
##   color : color - Color of the swipe (Default: Color(0, 0, 0))
##   direction : string ('left', 'right', 'up', 'down') - Which direction is the swipe coming from (Default: 'left')
func play_transition(type : String, options : Dictionary = {}) -> void:
	match (type):
		'FadeOut':
			fade_out_transition(options)
		'FadeIn':
			fade_in_transition(options)
		'SwipeOut':
			swipe_out_transition(options)
		'SwipeIn':
			swipe_in_transition(options)
		_:
			print('lmao')


# *** Avoid calling these functions directly, use the play_transition function instead! ***

func fade_out_transition(options) -> void:
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

func fade_in_transition(options) -> void:
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

func swipe_out_transition(options) -> void:
	if (not len(options) == 3): 
		options.duration = DEFAULTS.swipe.duration if not options.has('duration') else options.duration
		options.color = DEFAULTS.swipe.color if not options.has('color') else options.color
		options.direction = DEFAULTS.swipe.direction if not options.has('direction') else options.direction

	# Create the gradient we are going to use
	var grad = Gradient.new()
	grad.colors = PackedColorArray([Color(options.color.r, options.color.g, options.color.g, 1), Color(options.color.r, options.color.g, options.color.g, 0)])
	grad.set_offset(0, .01)

	# Create the 1d gradient texture using the gradient
	var grad_texture = GradientTexture1D.new()
	grad_texture.gradient = grad
	grad_texture.width = 1152

	# Create the TextureRect
	var texture_rect = TextureRect.new()
	texture_rect.size = Vector2(1500, 1500)
	texture_rect.texture = grad_texture
	texture_rect.z_index = 99

	# Handle Direction
	if (options.direction == 'up'):
		texture_rect.rotation_degrees = 90
		texture_rect.position = Vector2(1250, -250)
	elif (options.direction == 'down'):
		texture_rect.rotation_degrees = 270
		texture_rect.position = Vector2(0, 1250)
	elif (options.direction == 'right'):
		texture_rect.rotation_degrees = 180
		texture_rect.position = Vector2(1250, 750)
	else:
		texture_rect.position = Vector2(-250, -0)

	add_child(texture_rect)

	var tween = create_tween()
	tween.tween_method(func(value: float): grad.set_offset(0, value), -0.9, 0.99, options.duration)
	tween.tween_callback(texture_rect.queue_free)


func swipe_in_transition(options) -> void:
	if (not len(options) == 3): 
		options.duration = DEFAULTS.swipe.duration if not options.has('duration') else options.duration
		options.color = DEFAULTS.swipe.color if not options.has('color') else options.color
		options.direction = DEFAULTS.swipe.direction if not options.has('direction') else options.direction

	# Create the gradient we are going to use
	var grad = Gradient.new()
	grad.colors = PackedColorArray([Color(options.color.r, options.color.g, options.color.g, 0), Color(options.color.r, options.color.g, options.color.g, 1)])
	grad.set_offset(0, .01)

	# Create the 1d gradient texture using the gradient
	var grad_texture = GradientTexture1D.new()
	grad_texture.gradient = grad
	grad_texture.width = 1152

	# Create the TextureRect
	var texture_rect = TextureRect.new()
	texture_rect.size = Vector2(1500, 1500)
	texture_rect.texture = grad_texture
	texture_rect.z_index = 99

	# Handle Direction
	if (options.direction == 'up'):
		texture_rect.rotation_degrees = 90
		texture_rect.position = Vector2(1250, -250)
	elif (options.direction == 'down'):
		texture_rect.rotation_degrees = 270
		texture_rect.position = Vector2(0, 1250)
	elif (options.direction == 'right'):
		texture_rect.rotation_degrees = 180
		texture_rect.position = Vector2(1250, 750)
	else:
		texture_rect.position = Vector2(-250, -0)

	add_child(texture_rect)

	var tween = create_tween()
	tween.tween_method(func(value: float): grad.set_offset(0, value), -0.9, 0.99, options.duration)
	tween.tween_callback(texture_rect.queue_free)