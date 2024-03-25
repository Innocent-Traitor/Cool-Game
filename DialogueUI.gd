extends Control

@export var text_speed = 2  ## 1 = Slow, 2 = Normal, 3 = Fast

const DIALOGUE_DB = Dialogue_DB.DIALOGUE_DB
const CHARACTER_DB = Dialogue_DB.CHARACTER_DB

var current_scene = 'NO SCENE'
var current_talk = 'NO TALK'
var talk_index = 0
var is_talking = false
var do_animation = false

var has_choice = false
var current_choice = 0
var choices = []
var talk_override = -1

func _ready() -> void:
	process_mode = PROCESS_MODE_DISABLED


func _get_scene_load_request(scene : String):
	load_scene(scene)
	display_dialogue()

## Sets the Dialogue Box's Portrait, Text, and begins the display of text
func display_dialogue() -> void:
	if (str(current_scene) == "NO SCENE" or str(current_talk) == 'NO TALK'):
		print('ERROR! Either no scene or talk is set! \nCurrent Scene: ', current_scene, " Current Talk: ", current_talk)
		print('Returning to prevent crash! Please investigate to prevent further errors!')
		return
	var chara = CHARACTER_DB[current_talk.get('character')]
	
	adjust_textbox(chara)
	handle_vn_display()

	if 'choice1' in current_talk:
		has_choice = true
	
	if 'override' in current_talk:
		talk_override = current_talk.override

	if 'vars' in current_talk:
		$TextBox/TextBoxText.text = current_talk.text % current_talk.vars
	else:
		$TextBox/TextBoxText.text = current_talk.text


	$TextBox/TextBoxText.visible_characters = 0
	is_talking = true
	handle_text_display([])
	handle_portrait()

## Gradually display the dialogue box's text
func handle_text_display(options : Array) -> void:
	if ($TextBox/TextBoxText.visible_characters >= len($TextBox/TextBoxText.text) or not is_talking):
		is_talking = false
		$TextBox/TextBoxText.visible_characters = -1
		if (has_choice):
			handle_choice()
		return

	$TextBox/TextBoxText.visible_characters += text_speed
	await get_tree().create_timer(0.01666667).timeout
	handle_text_display(options)


## Load the next dialogue in the current LOADED scene
func load_next_dialogue() -> void:
	if (not talk_override == -1):
		talk_index = talk_override
		talk_override = -1
	else:
		talk_index += 1

	if (not talk_index > len(current_scene) - 1):
		current_talk = current_scene[talk_index]
		display_dialogue()
	else:
		current_scene = 'NO SCENE'
		current_talk = 'NO TALK'
		talk_index = 0
		is_talking = false
		await get_tree().create_timer(0.5).timeout
		visible = false
		get_tree().get_first_node_in_group('Player').is_busy = false
		process_mode = PROCESS_MODE_DISABLED


func load_scene(scene : String) -> void:
	current_scene = DIALOGUE_DB[scene]
	current_talk = current_scene[0]
	talk_index = 0

# Handles portrait animation if do_animation is truthy
func handle_portrait() -> void:
	if (not do_animation or not visible): return
	if (is_talking):
		$AnimationPlayer.play(current_talk.get('character') + '_Talk')
	else:
		var ran = randf()
		if (ran < 0.1):
			$AnimationPlayer.play(current_talk.get('character') + '_Blink')
		else:
			await get_tree().create_timer(1).timeout 
			handle_portrait()

## Adjust the textbox depending on if there is a name for the character or a portrait that exists
func adjust_textbox(chara) -> void:
	if (chara['portrait'] == null):
		$TextBox/TextBoxPortrait.visible = false
		do_animation = false

		$TextBox/TextBoxForegroundPanel.position = Vector2(94, 440)
		$TextBox/TextBoxText.position = Vector2(100, 443)
		$TextBox/TextBoxForegroundPanel.size = Vector2(961, 135)
		$TextBox/TextBoxText.size = Vector2(951, 120)
	else:
		$TextBox/TextBoxPortrait.visible = true
		$TextBox/TextBoxPortrait.texture = load(chara.get('portrait'))
		do_animation = true

		$TextBox/TextBoxForegroundPanel.position = Vector2(251, 440)
		$TextBox/TextBoxText.position = Vector2(256, 443)
		$TextBox/TextBoxForegroundPanel.size = Vector2(810, 135)
		$TextBox/TextBoxText.size = Vector2(800, 120)

	if (chara['name'] == null):
		$TextBox/TextBoxNamePanel.visible = false
		$TextBox/TextBoxNameText.text = ""
	else:
		$TextBox/TextBoxNamePanel.visible = true
		$TextBox/TextBoxNameText.text = chara['name']


func handle_vn_display():
	if (current_talk.has('body')):
		$VNCharacterArea.visible = true
		$VNCharacterArea/Character1.texture = load(current_talk['body'])
	else:
		$VNCharacterArea.visible = false


func handle_choice():
	for i in 8:
		if (current_talk.has('choice' + str(i))):
			choices.append(current_talk['choice' + str(i)])
	
	# Adjust the choice box size and position
	var size_dif = 40 * len(choices)
	$RPGChoice/ChoiceBoxBackground.size = Vector2(175, size_dif)
	$RPGChoice/ChoiceBoxBackground.position = Vector2(890, 400 - size_dif)
	$RPGChoice.visible = true

	# Create the label
	var label_pos = 368
	for i in len(choices):
		var label = Label.new()
		label.name = 'Choice' + str(i)
		label.text = choices[i]
		label.label_settings = load('res://label.tres')
		label.add_to_group('choices')
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		label.vertical_alignment = VERTICAL_ALIGNMENT_FILL
		label.size = Vector2(125, 25)
		label.position = Vector2(935, label_pos)
		label_pos -= 40 # Sets the position for the next choice
		$RPGChoice/ChoiceNodes.add_child(label)
	
	current_choice = 0


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('next'):
		if (has_choice and $TextBox/TextBoxText.visible_characters == -1):
			talk_override = current_talk.get('choice' + str(current_choice + 1) + '_dest')
			has_choice = false
			$RPGChoice.visible = false
			$RPGChoice/SelectionArrow.position.y = 368
			choices.clear()
			get_tree().call_group('choices', 'queue_free')

		if (not is_talking and not has_choice):
			load_next_dialogue()
		else:
			$TextBox/TextBoxText.visible_characters = -1
			is_talking = false
	
	if (has_choice):
		if (event.is_action_pressed('up') and not current_choice == len(choices) - 1):
			$RPGChoice/SelectionArrow.position.y -= 40
			current_choice += 1
		elif (event.is_action_pressed('down') and not current_choice == 0):
			$RPGChoice/SelectionArrow.position.y += 40
			current_choice -= 1


## Open RichTextLabel URLs
func _on_dialogue_text_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	handle_portrait()


# There is a stupid bug in v4.1 & v4.2 that get_tree() will just return null sometimes. This just stopped working for some reason.
# This signal goes off BEFORE _ready() is finished so the tree just doesn't *exist*?
# Even though, I have VIDEO PROOF and a version that this works JUST FINE!!! WTH?!
# IT WORKS ON THIS COMMIT: https://github.com/Innocent-Traitor/Cool-Game/commit/9b042ee80e09bc897f2a32a37ec1dfb7280d5503
# Why does it just not want to work now? This just makes me wanna cry.
# I guess right now we can just call the function that handle scene loading on the NPC object script (which isn't great but ok...)
#func _on_visibility_changed() -> void:
#	_get_scene_load_request('scene_1')
