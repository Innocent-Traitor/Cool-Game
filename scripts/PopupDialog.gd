extends Control

# Figure out how much space we need for the full text to be displayed
# Once we know, size the label node and then size the 9panelrect to fit around the label
# Finally, place the label in the world for the specified amount of time

# Problems:
	# How do can we tell the node to show up and send the params? Just have a function call or signal? Instantiate as a new node and spawn
	# It will only adjust the actual size based on the text at the end of the frame it was changed.
	# We have to wait until the end of the frame to make the other adjustments based on the labels size
	# (as long as nothing else has to wait until the end of the frame, this shouldn't be a big problem, just a nuisance)


### text:string = Text to display, pos:Vector2 = Position to display textbox, dur:int = Duration (in seconds) to display the textbox 
@export var text : String = "Placeholder"
@export var pos : Vector2 = Vector2(0, 0)
@export var dur : int = 5

func _ready():
	$PopupText.size = Vector2(0, 0)
	$PopupText.text = text
	global_position = pos
	z_index = 5
	call_deferred('adjust_9panel')

func adjust_9panel():
	var rect_size = Vector2($PopupText.size.x + 8, $PopupText.size.y + 2)
	$NinePatchRect.size.y = rect_size.y
	var tween = create_tween()
	tween.tween_property($NinePatchRect, 'size:x', rect_size.x, 0.5)
	tween.tween_callback(display_textbox)


func display_textbox():
	$PopupText.position += Vector2(4, 1)
	$PopupText.visible = true
	await get_tree().create_timer(dur).timeout
	queue_free()