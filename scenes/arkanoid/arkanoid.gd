extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dummy_init()


	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# Заглушка чтобы лиса имела силу какую-то
func dummy_init():
	GlobalState.fox_meeting_number += 1
	GlobalState.fox_speed_level +=1
