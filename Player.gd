extends CharacterBody2D

@export var speed = 400

var is_busy : bool = false

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	handle_movement()


func handle_movement() -> void:
	var dir = Input.get_vector("left", "right", "up", "down")
	velocity = dir * speed
	move_and_slide()


func do_interact(obj : Node) -> void:
	pass