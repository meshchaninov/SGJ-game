extends Node2D

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/text_story/TextStory.tscn")

func _ready() -> void:
	$AudioStreamPlayer2D.play(0.0)

func _input(event) -> void:
	if Input.is_action_just_pressed("Start game") and $StartButton.is_visible_in_tree():
		$StartButton.pressed.emit()
	 
