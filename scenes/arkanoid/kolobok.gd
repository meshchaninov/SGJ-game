extends CharacterBody2D

class_name Kolobok

const SPEED = 350.0
const INERTION = 0.07

var y_pressed_order = []
var x_pressed_order = []
var started_fight = false

var size = 15

func _ready() -> void:
	size = $CollisionShape2D.shape.get_rect().size.x

func startFight():
	attack()
	$Timer.start()
	started_fight = true
	
func endFight():
	$Timer.stop()
	started_fight = false
	
var push = false

signal damage
func hit():
	# Сделать мигание
	pass

func filerByValue(array, value):
	return array.filter(func(valueToCheck):
		return valueToCheck != value
		)

var speed_stages = [0.8, 1, 1.1, 1.2, 1.3]
func _physics_process(delta: float) -> void:

	if !started_fight:
		return
	var result_speed = speed_stages[GlobalState.speed] * SPEED

	
	if Input.is_action_just_released("up"):
		#y_pressed_order.erase('up')
		y_pressed_order = filerByValue(y_pressed_order, 'up')
	if Input.is_action_just_released("down"):
		#y_pressed_order.erase('down')
		y_pressed_order = filerByValue(y_pressed_order, 'down')

	if Input.is_action_just_released("left"):
		#x_pressed_order.erase('left')
		x_pressed_order = filerByValue(x_pressed_order, 'left')
	if Input.is_action_just_released("right"):
		#x_pressed_order.erase('right')
		x_pressed_order = filerByValue(x_pressed_order, 'right')
	
	if Input.is_action_just_pressed("up"):
		y_pressed_order.push_front('up')

	if Input.is_action_just_pressed("down"):
		y_pressed_order.push_front('down')
		
	if !push:
		if Input.is_action_just_pressed("left"):
			x_pressed_order.push_front('left')
			
		if Input.is_action_just_pressed("right"):
			x_pressed_order.push_front('right')
		

	if y_pressed_order.size() != 0 &&  y_pressed_order[0] == 'up':
		#velocity.y = -result_speed
		velocity.y =  move_toward(velocity.y, -result_speed, SPEED * (1-INERTION))
	if y_pressed_order.size() != 0 && y_pressed_order[0] == 'down':
		#velocity.y = result_speed
		velocity.y =  move_toward(velocity.y, result_speed, SPEED * (1-INERTION))
		
	if x_pressed_order.size() != 0 && x_pressed_order[0] == 'left':
		#velocity.x = -result_speed
		velocity.x =  move_toward(velocity.x, -result_speed, SPEED * (1-INERTION))
	if x_pressed_order.size() != 0 && x_pressed_order[0] == 'right':
		velocity.x =  move_toward(velocity.x, result_speed, SPEED * (1-INERTION))


	if y_pressed_order.size() == 0:
		velocity.y =  move_toward(velocity.y, 0, SPEED*INERTION)

	if !push && x_pressed_order.size() == 0:
		velocity.x = move_toward(velocity.x, 0, SPEED*INERTION)
	if push:
		velocity.x = 2300
		var timer = Timer.new()
		timer.one_shot= true
		timer.autostart = false
		timer.wait_time = 0.2
		timer.timeout.connect(func():
			push = false
			timer.queue_free()
			)
		add_child(timer)
		timer.start()
	move_and_slide()
	
@onready var BasicAttack = preload("res://scenes/arkanoid/attacks/kolobok/basic.tscn")

func attack():
	if GlobalState.attack == 1:
		var basicAttack = BasicAttack.instantiate()
		basicAttack.position = Vector2(global_position.x - $CollisionShape2D.shape.get_rect().size.x, global_position.y)
		owner.add_child(basicAttack)
		


func _on_timer_timeout() -> void:
	attack()
