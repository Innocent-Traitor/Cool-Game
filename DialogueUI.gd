extends Control

@export var text_speed = 2  ## 1 = Slow, 2 = Normal, 3 = Fast

var current_scene = 'NO SCENE'
var current_talk = 'NO TALK'
var talk_index = 0
var is_talking = false

func _ready() -> void:
	loadScene('scene_1')
	displayDialogue()

## Sets the Dialogue Box's Portrait, Text, and begins the display of text
func displayDialogue() -> void:
	$Portrait.texture = load(current_talk.portrait)
	$DialogueText.text = current_talk.text
	$DialogueText.visible_characters = 0
	is_talking = true
	handleTextDisplay([])
	handlePortait()


## Gradually display the dialogue box's text
func handleTextDisplay(options : Array) -> void:
	if ($DialogueText.visible_characters >= len($DialogueText.text) or not is_talking):
		is_talking = false
		return

	$DialogueText.visible_characters += text_speed
	await get_tree().create_timer(0.01666667).timeout
	handleTextDisplay(options)


## Load the next dialogue in the current scene
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


func handlePortait() -> void:
	if (is_talking):
		$AnimationPlayer.play('Talk')
	else:
		var ran = randf()
		if (ran < 0.1):
			$AnimationPlayer.play('Blink')
		else:
			await get_tree().create_timer(1).timeout
			handlePortait()


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed('next'):
		if (not is_talking):
			loadNextDialogue()
		else:
			$DialogueText.visible_characters = -1
			is_talking = false

const DIALOGUE_DB = {
	'scene_1': {
		0: {
			'portrait': 'res://sprites/frame1.png',
			'text': 'The quick brown fox jumped over the lazy dog.'
		},
		1: {
			'portrait': 'res://sprites/frame1.png',
			'text': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu'
		},
		2: {
			'portrait': 'res://sprites/frame1.png',
			'text': '[b]Bold[/b]  [i]Italics[/i]  [b][i]Bold Italics[/i][/b]  [u]Underline[/u]  [s]Strikethrough[/s]  [url=https://www.moonsoftstudios.com]URL[/url]  [img=32x32]res://icon.svg[/img]\n [color=#00beef]Colored[/color]  [bgcolor=#00beef]BGColored[/bgcolor]  [fgcolor=#00beef]FGColored[/fgcolor]  [outline_size=2][outline_color=#00beef]Outline[/outline_color][/outline_size]'
		},
		3: {
			'portrait': 'res://sprites/frame1.png',
			'text': '[pulse]Pulse[/pulse]  [wave]Wave[/wave]  [tornado]Tornado[/tornado]  [shake]Shake[/shake]  '
		},
	}
}

## Open RichTextLabel URLs
func _on_dialogue_text_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	handlePortait()