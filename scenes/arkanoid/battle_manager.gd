extends Node2D

@onready var main: Arkanoid = $".."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func start_fight():
	var long_splash = false
	if(GlobalState.fox_meeting_number == 1):
		splash()
		
	if(GlobalState.fox_meeting_number == 2):
		var bullet_hell = rng.randi_range(1,20) == 10 # 5%
		if(bullet_hell):
			splash()
			splashAdditional()
		else:
			var ordinary = rng.randi_range(1,2) == 2
			if(ordinary):
				splash()
			else:
				splashAdditional()
				
	if(GlobalState.fox_meeting_number == 3):
		var bullet_hell = rng.randi_range(1,20) == 10 # 5%
		var fast_result =  rng.randi_range(1,2) == 1
		var degree = 90
		if(fast_result):
			degree = 170
		var time = 2
		if(fast_result):
			long_splash = true
			time = 4
		
		
		if(bullet_hell):
			splash()
			splashAdditional(degree, time)
		else:
			var ordinary = rng.randi_range(1,2) == 2
			if(ordinary):
				splash()
			else:
				splashAdditional(degree, time)
				
	var wait_time = rng.randf_range(2.1, 4)
	if(long_splash):
		rng.randf_range(5.1, 6)
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
func splash(value = 90.0):
	var both = rng.randi_range(1,2) == 2
	print(splash)
	if (both):
		$FireSplashMakerUp.start_fire_default(90.0)
		$FireSplashMakerDown.start_fire_default(-100.0)
	else:
		var rand_result = rng.randi_range(1,2)
		if(rand_result == 1):
			$FireSplashMakerUp.start_fire_default(90.0)
		else:
			$FireSplashMakerDown.start_fire_default(-100.0)

func splashAdditional(value = 90.0, time= 2.0):
	var both = rng.randi_range(1,2) == 2
	
	print('TEST ' + str(value) + ' ' + str(time))
	if (both):
		$FireSplashMakerUp2.start_fire_default(value, time)
		$FireSplashMakerDown2.start_fire_default(-value-10, time)
	else:
		var rand_result = rng.randi_range(1,2) == 1
		#var fast_result =  rng.randi_range(1,2) == 1
		if(rand_result):
			$FireSplashMakerUp2.start_fire_default(value, time)
		else:
			print(value, time)
			$FireSplashMakerDown2.start_fire_default(-value-10, time)
			
