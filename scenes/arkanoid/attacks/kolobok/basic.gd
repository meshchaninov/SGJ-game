extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GlobalState.attack == 1:
		$Sprites/Basic.visible = true
	else:
		$Sprites/Lazer.visible = true
	$AudioStreamPlayer2D.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

const  default_speed = 1500

func _physics_process(delta):
	position -= transform.x * default_speed * delta
	
func _on_Bullet_body_entered(body):
	if body.is_in_group("fox"):
		body.queue_free()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
