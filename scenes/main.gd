extends Node2D

func _ready() -> void:
	new_game()

func new_game():
	$StartScene.show()
	$EndScene.hide()
	$TextStory.hide()

func _on_start_scene_start() -> void:
	$StartScene.hide()
	$TextStory.show()

func _on_end_scene_end() -> void:
	new_game()
	
