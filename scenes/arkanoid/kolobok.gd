extends CharacterBody2D


const SPEED = 350.0
const INERTION = 0.07

var y_pressed_order = []
var x_pressed_order = []

func startFight():
	attack()
	$Timer.start()

func _physics_process(delta: float) -> void:
	
	var result_speed = GlobalState.speed * SPEED

	if Input.is_action_just_released("up") || Input.is_action_just_released("down"):
		if Input.is_action_just_released("up"):
			y_pressed_order.erase('up')
		if Input.is_action_just_released("down"):
			y_pressed_order.erase('down')
		
	if Input.is_action_just_released("left") || Input.is_action_just_released("right"):
		if Input.is_action_just_released("left"):
			x_pressed_order.erase('left')
		if Input.is_action_just_released("right"):
			x_pressed_order.erase('right')
	
	if Input.is_action_just_pressed("up"):
		y_pressed_order.push_front('up')

	if Input.is_action_just_pressed("down"):
		y_pressed_order.push_front('down')
		
	if Input.is_action_just_pressed("left"):
		x_pressed_order.push_front('left')
		
	if Input.is_action_just_pressed("right"):
		x_pressed_order.push_front('right')
		
		
	if y_pressed_order.size() != 0 &&  y_pressed_order[0] == 'up':
		velocity.y = -result_speed
	if y_pressed_order.size() != 0 && y_pressed_order[0] == 'down':
		velocity.y = result_speed
		
	if x_pressed_order.size() != 0 && x_pressed_order[0] == 'left':
		velocity.x = -result_speed
	if x_pressed_order.size() != 0 && x_pressed_order[0] == 'right':
		velocity.x = result_speed


	if y_pressed_order.size() == 0:
		velocity.y =  move_toward(velocity.y, 0, SPEED*INERTION)
		
	if x_pressed_order.size() == 0:
		velocity.x =  move_toward(velocity.x, 0, SPEED*INERTION)

	move_and_slide()
	
var BasicAttack = preload("res://scenes/arkanoid/attacks/kolobok/basic.tscn")

func attack():
	if GlobalState.attack == 1:
		var attack = BasicAttack.instantiate()
		attack.position = Vector2(global_position.x - $CollisionShape2D.shape.get_rect().size.x, global_position.y)
		owner.add_child(attack)
		


func _on_timer_timeout() -> void:
	attack()
