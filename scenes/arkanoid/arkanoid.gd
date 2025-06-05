extends Node2D
class_name Arkanoid

@onready var kolobok = $Kolobok
@onready var HpControl = $Control/HP
@onready var fox = $Fox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HpControl.text = 'Здоровьице: ' + str(Hp)
	
	# TODO: это заглушки, стереть когда всё готово
	#dummy_init()
	start_scene()
	

var Hp = GlobalState.max_hp
var foxHp = GlobalState.fox_hp

var start_fight = false
	
# Подрубать перед появлением сцены
func start_scene():
	Hp = GlobalState.max_hp
	foxHp = GlobalState.fox_hp
	fox.init()
	bg_init()
	$Control/ProgressBar.value = foxHp
	$Control/ProgressBar.max_value = GlobalState.MAX_FOX_HP
	$Kolobok.position = Vector2(700, 310)
	$Kolobok.init()
	$TimerBeforeStart.start(3)
	#$AudioStreamPlayer2D.loo
	$AudioStreamPlayer2D.play()
	if !GlobalState.first_fight:
		$Control/ControlGuide.visible = false
	else:
		GlobalState.first_fight = false
	
func bg_init():
	$Background/Background1.visible = false
	$Background/Background2.visible = false
	$Background/Background3.visible = false
	print(GlobalState.fox_meeting_number)
	if(GlobalState.fox_meeting_number == 1):
		$Background/Background1.visible = true
	if(GlobalState.fox_meeting_number == 2):
		$Background/Background2.visible = true
	if(GlobalState.fox_meeting_number == 3):
		$Background/Background3.visible = true

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
			$Control/ControlGuide.visible = false
			timerHide.queue_free()
			)
		add_child(timerHide)
		timerHide.start()
	if not $AudioStreamPlayer2D.is_playing():
		$AudioStreamPlayer2D.play(0.0)

# Заглушка чтобы лиса имела силу какую-то
func dummy_init():
	GlobalState.fox_meeting_number += 3
	GlobalState.fox_speed_level +=4
	GlobalState.attack = 1

func _on_timer_before_start_timeout() -> void:
	print('START FIGHT')
	start_fight = true
	kolobok.startFight()
	$BattleManager.start_fight()
	# TODO: тут еще лису подрубать

func damage():
	Hp-= 1
	HpControl.text = 'Здоровьице: ' + str(Hp)
	if(Hp == 0):
		on_lose()


#signal hit_fox
func _on_hit_fox() -> void:
	foxHp-=1
	#print('HIT FOX ' + str(foxHp))
	#print('Maxs FOX ' + str($Control/ProgressBar.max_value) )
	$Control/ProgressBar.value = foxHp
	
	var stage_index = GlobalState.fox_meeting_number - 1
	print(GlobalState.fox_meeting_number)
	var fox_health_to_win_stage = GlobalState.FOX_HP_STAGES[stage_index]
	if(fox_health_to_win_stage >= foxHp):
		foxHp = fox_health_to_win_stage
		GlobalState.fox_hp = fox_health_to_win_stage
		on_win()
	

func on_win() -> void:
	stop_scene()
	if GlobalState.last_fight:
		GlobalState.end_result = "happy"
	get_tree().change_scene_to_file("res://scenes/text_story/TextStory.tscn")

func on_lose() -> void:
	stop_scene()
	GlobalState.end_result = "bad"
	get_tree().change_scene_to_file("res://scenes/start_end/EndScene.tscn")


var invincible = false
func _on_kolobok_damage() -> void:
	if(!invincible):
		invincible = true
		$InvincibleTimer.start(1)
		damage()


func _on_invincible_timer_timeout() -> void:
	invincible = false
