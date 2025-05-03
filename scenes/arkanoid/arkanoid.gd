extends Node2D
class_name Arkanoid

signal win
signal loose

@onready var kolobok = $Kolobok
@onready var HpControl = $Control/HP
@onready var fox = $Fox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dummy_init()
	HpControl.text = 'Здоровьеце: ' + str(Hp)

var Hp = GlobalState.max_hp
var foxHp = GlobalState.fox_hp

var start_fight = false
	
# Подрубать перед появлением сцены
func start_scene():
	Hp = GlobalState.max_hp
	foxHp = GlobalState.fox_hp
	fox.init()
	$Control/ProgressBar.value = foxHp
	$Kolobok.position = Vector2(1190, 310)
	$TimerBeforeStart.start(3)
	
func stop_scene():
	start_fight = false
	kolobok.endFight()
	$BattleManager.start_fight()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time_left: float = $TimerBeforeStart.time_left
	var timerLabel: Label = $Control/TimerLabel
	if(!timerLabel.visible):
		return
	if(time_left != 0):
		timerLabel.text = str(int(round(time_left)))
	else:
		var timerHide = Timer.new()
		timerHide.one_shot= true
		timerHide.autostart = false
		timerHide.wait_time = 0.3
		timerHide.timeout.connect(func():
			timerLabel.visible = false
			timerHide.queue_free()
			)
		add_child(timerHide)
		timerHide.start()
	
# Заглушка чтобы лиса имела силу какую-то
func dummy_init():
	GlobalState.fox_meeting_number += 1
	GlobalState.fox_speed_level +=1

func _on_timer_before_start_timeout() -> void:
	print('START FIGHT')
	start_fight = true
	kolobok.startFight()
	$BattleManager.start_fight()
	# TODO: тут еще лису подрубать

func damage():
	Hp-= 1
	HpControl.text = 'Здоровьеце: ' + str(Hp)
	if(Hp == 0):
		on_lose()


#signal hit_fox
func _on_hit_fox() -> void:
	foxHp-=1
	$Control/ProgressBar.value = foxHp
	
	var stage_index = GlobalState.fox_meeting_number - 1
	
	var fox_health_to_win_stage = GlobalState.FOX_HP_STAGES[stage_index]
	if(fox_health_to_win_stage >= foxHp):
		foxHp = fox_health_to_win_stage
		GlobalState.fox_hp = fox_health_to_win_stage
		on_win()
	

func on_win() -> void:
	stop_scene()
	win.emit()

func on_lose() -> void:
	stop_scene()
	loose.emit()


var invincible = false
func _on_kolobok_damage() -> void:
	if(!invincible):
		invincible = true
		$InvincibleTimer.start(1)
		damage()


func _on_invincible_timer_timeout() -> void:
	invincible = false
