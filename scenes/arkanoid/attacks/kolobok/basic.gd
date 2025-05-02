extends Area2D
class_name Basic

var end = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GlobalState.attack == 1:
		$Sprites/Basic.visible = true
		$AudioBasic.play()
	else:
		$Sprites/Lazer.visible = true
		$AudioBasic.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

const  default_speed = 1500

func _physics_process(delta):
	if end:
		return
	position -= transform.x * default_speed * delta
	
func _on_Bullet_body_entered(body: Node2D):
	print(body.name)

		


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if is_queued_for_deletion():
		# The signal has been emitted because the node is being freed
		pass
	else:
		# The signal has been emitted because the node is outside the screen
		queue_free()
	

func hit():
	print('Hit in bullet')
	end = true
	$Hit.visible = true
	var timer = Timer.new()
	timer.one_shot= true
	timer.autostart = false
	timer.wait_time = 0.05
	timer.timeout.connect(func():
		queue_free()
		)
	add_child(timer)
	timer.start()
	

func _on_area_entered(area: Area2D) -> void:
	if area.name == 'Fox':
		hit()
		area.hit.emit()
