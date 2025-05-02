extends CharacterBody2D


const SPEED = 350.0

var pressed_x = false
var pressed_y = false

func _physics_process(delta: float) -> void:
	
	var result_speed = GlobalState.speed * SPEED

	if Input.is_action_just_released("up") || Input.is_action_just_released("down"):
		pressed_y = false
		velocity.y =  move_toward(velocity.y, 0, SPEED*0.9)
		
	if Input.is_action_just_released("left") || Input.is_action_just_released("right"):
		velocity.x =  move_toward(velocity.x, 0, SPEED*0.9)
		pressed_x = false
	
	if Input.is_action_just_pressed("up"):
		pressed_y = true
		print('UP')
		print('Speed ' + str(result_speed))
		print(velocity.y)
		velocity.y += -result_speed
		print(velocity.y)

	if Input.is_action_just_pressed("down"):
		pressed_y = true
		velocity.y = result_speed
		
	
		
		
	if Input.is_action_just_pressed("left"):
		velocity.x = -result_speed
		
	if Input.is_action_just_pressed("right"):
		velocity.x = result_speed
		


	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	move_and_slide()
