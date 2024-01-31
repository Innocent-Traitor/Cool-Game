extends Control

@export var text_speed = 2  ## 1 = Slow, 2 = Normal, 3 = Fast

var current_scene = 'NO SCENE'
var current_talk = 'NO TALK'
var talk_index = 0

func _ready() -> void:
	loadScene('scene_1')
	displayDialogue()

## Sets the Dialogue Box's Portrait, Text, and begins the display of text
func displayDialogue() -> void:
	$Portrait.texture = load(current_talk.portrait)
	$DialogueText.text = current_talk.text
	$DialogueText.visible_characters = 0
	handleTextDisplay([])


## Gradually display the dialogue box's text
func handleTextDisplay(options : Array) -> void:
	if ($DialogueText.visible_ratio == 1.0):
		return

	$DialogueText.visible_characters += text_speed
	await get_tree().create_timer(0.01666667).timeout
	handleTextDisplay(options)


### Load the next dialogue in the current scene
func loadNextDialogue() -> void:
	talk_index += 1
	if (not talk_index > len(current_scene) - 1):
		current_talk = current_scene[talk_index]
		displayDialogue()
	else:
		print('no more text')


func loadScene(scene : String) -> void:
	current_scene = DIALOGUE_DB[scene]
	current_talk = current_scene[0]
	talk_index = 0


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed('next'):
		loadNextDialogue()


const DIALOGUE_DB = {
	'scene_1': {
		0: {
			'portrait': 'res://icon.svg',
			'text': 'The quick brown fox jumped over the lazy dog.'
		},
		1: {
			'portrait': 'res://icon.svg',
			'text': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu'
		},
		2: {
			'portrait': 'res://icon.svg',
			'text': '[b]Bold[/b]  [i]Italics[/i]  [b][i]Bold Italics[/i][/b]  [u]Underline[/u]  [s]Strikethrough[/s]  [url=https://www.moonsoftstudios.com]URL[/url]  [img=32x32]res://icon.svg[/img]\n [color=#00beef]Colored[/color]  [bgcolor=#00beef]BGColored[/bgcolor]  [fgcolor=#00beef]FGColored[/fgcolor]  [outline_size=2][outline_color=#00beef]Outline[/outline_color][/outline_size]'
		},
		3: {
			'portrait': 'res://icon.svg',
			'text': '[pulse]Pulse[/pulse]  [wave]Wave[/wave]  [tornado]Tornado[/tornado]  [shake]Shake[/shake]  '
		},
	}
}

## Open RichTextLabel URLs
func _on_dialogue_text_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))