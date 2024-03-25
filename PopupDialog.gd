extends Control

# Figure out how much space we need for the full text to be displayed
# Once we know, size the label node and then size the 9panelrect to fit around the label
# Finally, place the label in the world for the specified amount of time

# Problems:
	# How do can we tell the node to show up and send the params? Just have a function call or signal?
	# It will only adjust the actual size based on the text at the end of the frame it was changed.
	# We have to wait until the end of the frame to make the other adjustments based on the labels size
	# (as long as nothing else has to wait until the end of the frame, this shouldn't be a big problem, just a nuisance)



func _ready():
	$PopupText.size = Vector2(0, 0)
	$PopupText.text = 'How much space do we need?'
	call_deferred('print_size')

func print_size():
	print($PopupText.size)