extends Node2D
class_name Arkanoid

@onready var kolobok = $Kolobok
@onready var HpControl = $Control/HP
@onready var fox = $Fox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dummy_init()
	HpControl.text = 'Здоровьеце: ' + str(Hp)
	start_scene()

var Hp = GlobalState.max_hp
var foxHp = GlobalState.fox_hp
	
# Подрубать перед появлением сцены
func start_scene():
	Hp = GlobalState.max_hp
	foxHp = GlobalState.fox_hp
	fox.init()
	$Control/ProgressBar.value = foxHp
	$Kolobok.position = Vector2(1190, 310)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# Заглушка чтобы лиса имела силу какую-то
func dummy_init():
	GlobalState.fox_meeting_number += 1
	GlobalState.fox_speed_level +=1


func _on_timer_before_start_timeout() -> void:
	print('FIGHT START')
	kolobok.startFight()
	# TODO: тут еще лису подрубать

func damage():
	Hp-= 1
	HpControl.text = 'Здоровьеце: ' + str(Hp)


#signal hit_fox
func _on_hit_fox() -> void:
	foxHp-=1
	$Control/ProgressBar.value = foxHp
	print(foxHp)
