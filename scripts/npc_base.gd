extends AnimatableBody2D
class_name NonPlayableCharacter

@export var npc_name : String = 'NPC'
@export_enum("FRIENDLY", "NEUTRAL", "HOSTILE") var npc_relationship : int
@export_enum("NPC_TALK", "NPC_SHOP") var npc_interact : String


func handle_interact(): 
	pass


func send_interact_info():
	var player = get_tree().get_first_node_in_group('Player')
	player.recieve_interact_info([npc_interact])
		





