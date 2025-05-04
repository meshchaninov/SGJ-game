extends Node2D

@onready var main: Arkanoid = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func rotateToKolobok(lazer: Lazer):
	var kolobok: Kolobok = $"../Kolobok"
	var angleTo = lazer.transform.x.angle_to_point(kolobok.global_position)
	lazer.look_at(kolobok.global_position)
	
func lazer_eye():
	lazer_eye_is_active = true
	var lazerEye: Lazer = $LazerEye
	rotateToKolobok(lazerEye)
	lazerEye.startShot()
	
func _on_lazer_eye_shot_ended(lazer: Lazer) -> void:
	lazer_eye_is_active = false

var lazerBottomArray = []
func _on_lazer_down_shot_started(lazer: Lazer) -> void:
	lazerBottomArray.push_back(lazer)

func _on_lazer_down_shot_ended(lazer: Lazer) -> void:
	lazerBottomArray.erase(lazer)
	lazer_bottom_is_active = lazerBottomArray.size() == 0

var lazer_bottom_is_active = false
var lazer_eye_is_active = false

func lazer_bottom():
	lazer_bottom_is_active = true
	var ordinary = rng.randi_range(1,2) == 2
	var sync = rng.randi_range(1,2) == 2
	var lazers

	if($"..".foxHp < GlobalState.FOX_HP_STAGES[1]/2):
		lazers = [$LazerDown1, $LazerDown2, $LazerDown3, $LazerDown4, $LazerDown5, $LazerLeft1, $LazerLeft]
	else:
		lazers = [$LazerDown1, $LazerDown2, $LazerDown3, $LazerDown4, $LazerDown5]

	for lazer in lazers:
		if !ordinary:
			rotateToKolobok(lazer)
		if(sync):
			await lazer.startShot(true)
		else:
			lazer.startShot()
		
func start_fight():
	var attack_time = 2

	if(GlobalState.fox_meeting_number == 1):
		attack_time = rng.randf_range(1, 4)
		await splash(90, attack_time, 70)
		
	if(GlobalState.fox_meeting_number == 2):
		var bullet_hell = rng.randi_range(1,10) <= 7 #70%
		attack_time = rng.randf_range(1.8, 4)
		var should_lazer_eye  =  rng.randi_range(1,20) <= 14 #70%
		if(should_lazer_eye && !lazer_eye_is_active):
			lazer_eye()
		if(bullet_hell):
			splash(90, attack_time)
			splashAdditional(90, attack_time)
		else:
			var ordinary = rng.randi_range(1,2) == 2
			if(ordinary):
				splash(90, attack_time)
			else:
				splashAdditional(90, attack_time)
				
	if(GlobalState.fox_meeting_number == 3):
		var bullet_hell = rng.randi_range(1,10) <= 7 #70%
		var big_degree =  rng.randi_range(1,2) == 1
		var degree = 90
		var fire_bottom_lazers = rng.randi_range(1,20) <= 12 #70%
		
		var should_lazer_eye  =  rng.randi_range(1,20) <= 12 #70%
		if(should_lazer_eye && !lazer_eye_is_active):
			lazer_eye()
		
		if(big_degree):
			degree = 170
			attack_time = rng.randf_range(4, 6)
		else:
			attack_time = rng.randf_range(1.8, 3)
			
		if(bullet_hell):
			splash(90, attack_time)
			splashAdditional(degree, attack_time)
		else:
			var ordinary = rng.randi_range(1,2) == 2
			if(ordinary):
				splash(90, attack_time, 8)
			else:
				splashAdditional(degree, attack_time)
		if(fire_bottom_lazers && !lazer_bottom_is_active):
			lazer_bottom()

	var wait_time = attack_time+0.2
	var timer = Timer.new()
	timer.one_shot= true
	timer.autostart = false
	timer.wait_time = wait_time
	timer.timeout.connect(func():
		if(main.start_fight):
			start_fight()
		timer.queue_free()
		)
	add_child(timer)
	timer.start()
	
var rng = RandomNumberGenerator.new()
func splash(value = 90.0, time= 2.0, percent = 5):
	var both = rng.randi_range(1,10) <= percent
	if (both):
		$FireSplashMakerUp.start_fire_default(value)
		$FireSplashMakerDown.start_fire_default(-value-10)
	else:
		var rand_result = rng.randi_range(1,2)
		if(rand_result == 1):
			$FireSplashMakerUp.start_fire_default(value)
		else:
			$FireSplashMakerDown.start_fire_default(-value-10)

func splashAdditional(value = 90.0, time= 2.0):
	var both = rng.randi_range(1,2) == 2
	
	#print('TEST ' + str(value) + ' ' + str(time))
	if (both):
		$FireSplashMakerUp2.start_fire_default(value, time)
		$FireSplashMakerDown2.start_fire_default(-value-10, time)
	else:
		var rand_result = rng.randi_range(1,2) == 1
		#var fast_result =  rng.randi_range(1,2) == 1
		if(rand_result):
			$FireSplashMakerUp2.start_fire_default(value, time)
		else:
			$FireSplashMakerDown2.start_fire_default(-value-10, time)
			
