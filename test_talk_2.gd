extends NonPlayableCharacter


func handle_interact():
	match npc_interact:
		'NPC_TALK':
			print('I AM TALKING')
			var talk_box = get_tree().get_first_node_in_group('DialogueBox')
			print(talk_box)
			talk_box.process_mode = PROCESS_MODE_INHERIT
			talk_box.visible = true
			talk_box._get_scene_load_request('scene_2')
			send_interact_info()

		'NPC_SHOP':
			print('shopping :)')
		_:
			print('what')