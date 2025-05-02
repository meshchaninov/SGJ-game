extends Node2D

func _ready() -> void:
	new_game()

func new_game():
	$StartScene.show()
	$EndScene.hide()

func _on_start_scene_start() -> void:
	$StartScene.hide()
	var text_scene = preload("res://scenes/TextStory.tscn").instantiate()
	text_scene.position = Vector2(0, 720)
	add_child(text_scene)
