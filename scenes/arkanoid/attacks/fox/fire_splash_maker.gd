extends Node2D

@export var kolobok: Kolobok

var start_fire = false
#@export var max_count = 20
#var count = 0
var gap = 0

var last_fire_ball: FireBall

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	#if(!start_fire || count >= max_count): return
	if(start_fire):
		attack()
	
	
@onready var BasicAttack = preload("res://scenes/arkanoid/attacks/fox/fireBall.tscn")

func start_fire_default(value: float = 90.0, tweenTime: float = 2.0) -> void:
	if(gap == 0):
		gap = round(kolobok.size) + 40

	var tween = $Maker.create_tween()

	tween.tween_property($Maker, 'rotation_degrees', value, tweenTime)
	start_fire = true
	tween.tween_callback(func():
		$Maker.rotation_degrees = 0
		print('START_FIRE END')
		start_fire = false
		)
	

func attack():
	if(last_fire_ball):
		var pos = position.distance_to(last_fire_ball.position) + last_fire_ball.size
		if(pos >=gap):
			var basicAttack: FireBall = BasicAttack.instantiate()
			basicAttack.position = Vector2($Maker.global_position.x, $Maker.global_position.y)
			basicAttack.global_rotation = $Maker.global_rotation
			last_fire_ball = basicAttack
			owner.add_child(basicAttack)
	else:
		var basicAttack: FireBall = BasicAttack.instantiate()
		basicAttack.position = Vector2($Maker.global_position.x, $Maker.global_position.y)
		basicAttack.global_rotation = $Maker.global_rotation
		last_fire_ball = basicAttack
		owner.add_child(basicAttack)
