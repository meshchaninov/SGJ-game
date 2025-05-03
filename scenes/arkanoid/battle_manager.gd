extends Node2D

@onready var main: Arkanoid = $".."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func start_fight():
	if(GlobalState.fox_meeting_number ==1):
		var both = rng.randi_range(1,2) == 2
		splash(both)
	var wait_time = rng.randf_range(2.1, 4)
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
func splash(both = false):
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
