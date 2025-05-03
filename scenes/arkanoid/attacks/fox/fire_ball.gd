extends Area2D
class_name FireBall

var default_speed = 310

var size = 30

var speed_stages = [0.6, 0.8, 1, 1.2, 1.3, 1.5, 1.7]

func _physics_process(delta):
	var speed = default_speed * speed_stages[GlobalState.fox_speed_level]
	position += transform.x * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if is_queued_for_deletion():
		# The signal has been emitted because the node is being freed
		pass
	else:
		# The signal has been emitted because the node is outside the screen
		queue_free()


func _on_area_entered(body: Area2D) -> void:
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	if body.name == 'Kolobok': 
		body.damage.emit()
