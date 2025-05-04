extends Node2D
class_name Lazer

@export var fox_visible = false

var can_hit = false
var kolobok_inside = false

@export var kolobok: Kolobok


func _ready() -> void:
	$Fox1.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	if(can_hit && kolobok_inside):
		can_hit = false
		kolobok.damage.emit()

const speed_const = [1, 1.2, 1.3 , 1.4, 1.5, 1.6, 1.7, 1.8]

signal shot_started(lazer: Lazer)
signal shot_ended(lazer: Lazer)
var fast = false
func startShot(fast_param = false):
	shot_started.emit(self)
	fast = fast_param
	if (fast):
		$AnimationPlayer.speed_scale = speed_const[GlobalState.fox_speed_level]*1.3
	else:
		$AnimationPlayer.speed_scale = speed_const[GlobalState.fox_speed_level]
	
	if(fox_visible):
		$AnimationPlayer.play("EnterScene")
		$Fox1.visible = true
		await $AnimationPlayer.animation_finished
		
	
	$AnimationPlayer.play("LazerAttack")
	await $AnimationPlayer.animation_finished

	if(fox_visible):
		$AnimationPlayer.play("LeftScene")
		await $AnimationPlayer.animation_finished
		$Fox1.visible = false 
	shot_ended.emit(self)
	

func showPreLazer():
	$PreLazer.visible = true

func soundLazer():
	if (fast):
		$LazerSound.pitch_scale = speed_const[GlobalState.fox_speed_level]*1.3
	else:
		$LazerSound.pitch_scale = speed_const[GlobalState.fox_speed_level]
	$LazerSound.play()
	$Area2D/CollisionShapeFlash.visible=true
	
func reset():
	#can_hit = false
	$Area2D/CollisionShapeFlash.visible = false
	$PreLazer.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == 'Kolobok': 
		kolobok_inside = true


func _on_collision_shape_flash_visibility_changed() -> void:
	can_hit = $Area2D/CollisionShapeFlash.visible



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == 'Kolobok': 
		kolobok_inside = false
