extends Node2D

func _ready() -> void:
	new_game()

func new_game():
	$StartScene.show()
	$EndScene.hide()
	$TextStory.hide()
	$Arcanoid.hide()

func _on_start_scene_start() -> void:
	$StartScene.hide()
	$TextStory.show()

func _on_end_scene_end_game() -> void:
	new_game()

func _on_text_story_start_fight() -> void:
	$TextStory.hide()
	$Arcanoid.show()

func _on_text_story_end_signal() -> void:
	$TextStory.hide()
	new_game()

func _on_arcanoid_loose() -> void:
	$EndScene.show()

func _on_arcanoid_win() -> void:
	$Arcanoid.hide()
	
