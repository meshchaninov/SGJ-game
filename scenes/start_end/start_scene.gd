extends Node2D

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/TextStory.tscn")

func _ready() -> void:
	$AudioStreamPlayer2D.play(0.0)
