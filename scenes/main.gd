extends Node2D

func _ready() -> void:
	get_tree().change_scene_to_file("res://scenes/start_end/StartScene.tscn")
