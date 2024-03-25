extends Node
class_name Game_Utils

## Displays an onscreen popup
func display_popup(text : String = 'Placeholder', pos : Vector2 = Vector2(0, 0), dur : int = 3):
	var popup = preload("res://scenes/popup_dialog.tscn").instantiate()
	popup.text = text
	popup.pos = pos
	popup.dur = dur
	add_child(popup)
