extends PhysicsBody2D
class_name MovingNPC

## TODO: Change this to an actual movement and collosion system
func do_random_move():
	var new_pos = Vector2(global_position.x + randi_range(-200, 200), global_position.y + randi_range(-50, 50))
	$AnimatedSprite2D.play('Run')
	if (new_pos.x > global_position.x):
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	var tween = create_tween()
	tween.tween_property(self, 'global_position', new_pos, randf_range(1, 3))
	tween.tween_callback(make_new_timer)


func make_new_timer():
	$Timer.wait_time = randi_range(1, 10)
	$Timer.start()
	$AnimatedSprite2D.play('Idle')


func _on_timer_timeout():
	#do_random_move()
	pass


func do_movement():
	move_and_collide(Vector2.UP)


func _physics_process(_delta):
	do_movement()
