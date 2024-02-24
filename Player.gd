extends CharacterBody2D

@export var speed = 400

var is_busy : bool = false

func _ready() -> void:
	print("ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (not is_busy):
		handle_movement()


func handle_movement() -> void:
	var dir = Input.get_vector("left", "right", "up", "down")
	velocity = dir * speed
	move_and_slide()

	match dir:
		Vector2(1, 0):
			$InteractBody.position = Vector2(50, 0)
		Vector2(-1, 0):
			$InteractBody.position = Vector2(-50, 0)
		Vector2(0, 1):
			$InteractBody.position = Vector2(0, 50)
		Vector2(0, -1):
			$InteractBody.position = Vector2(0, -50)



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('next') and not is_busy:
		var body = $InteractBody.get_overlapping_areas()
		if body:
			do_interact(body[0])
			print('interacting with ' + str(body[0]))


func do_interact(obj : Node) -> void:
	obj.get_parent().handle_interact()


func recieve_interact_info(info : Array) -> void:
	print('Got info from interaction: ' + str(info))
	is_busy = true
