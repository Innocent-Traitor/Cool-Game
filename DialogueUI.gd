extends Control

@export var text_speed = 2  ## 1 = Slow, 2 = Normal, 3 = Fast

const DIALOGUE_DB = Dialogue_DB.DIALOGUE_DB
const CHARACTER_DB = Dialogue_DB.CHARACTER_DB

var current_scene = 'NO SCENE'
var current_talk = 'NO TALK'
var talk_index = 0
var is_talking = false

func _ready() -> void:
	process_mode = PROCESS_MODE_DISABLED


func _get_scene_load_request(scene : String):
	load_scene(scene)
	display_dialogue()

## Sets the Dialogue Box's Portrait, Text, and begins the display of text
func display_dialogue() -> void:
	var chara = CHARACTER_DB[current_talk.get('character')]
	$Portrait.texture = load(chara.get('portrait'))
	if 'vars' in current_talk:
		$DialogueText.text = current_talk.text % current_talk.vars
	else:
		$DialogueText.text = current_talk.text
	$DialogueText.visible_characters = 0
	is_talking = true
	handle_text_display([])
	handle_portrait()


## Gradually display the dialogue box's text
func handle_text_display(options : Array) -> void:
	if ($DialogueText.visible_characters >= len($DialogueText.text) or not is_talking):
		is_talking = false
		return

	$DialogueText.visible_characters += text_speed
	await get_tree().create_timer(0.01666667).timeout
	handle_text_display(options)


## Load the next dialogue in the current scene
func load_next_dialogue() -> void:
	talk_index += 1
	if (not talk_index > len(current_scene) - 1):
		current_talk = current_scene[talk_index]
		display_dialogue()
	else:
		await get_tree().create_timer(0.5).timeout
		get_tree().get_first_node_in_group('Player').is_busy = false
		current_scene = 'NO SCENE'
		current_talk = 'NO TALK'
		talk_index = 0
		is_talking = false
		visible = false
		process_mode = PROCESS_MODE_DISABLED




func load_scene(scene : String) -> void:
	current_scene = DIALOGUE_DB[scene]
	current_talk = current_scene[0]
	talk_index = 0


func handle_portrait() -> void:
	if (is_talking):
		$AnimationPlayer.play(current_talk.get('character') + '_Talk')
	else:
		var ran = randf()
		if (ran < 0.1):
			$AnimationPlayer.play(current_talk.get('character') + '_Blink')
		else:
			await get_tree().create_timer(1).timeout
			handle_portrait()


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed('next'):
		if (not is_talking):
			load_next_dialogue()
		else:
			$DialogueText.visible_characters = -1
			is_talking = false


## Open RichTextLabel URLs
func _on_dialogue_text_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	handle_portrait()

func _on_visibility_changed() -> void:
	_get_scene_load_request('scene_1')
