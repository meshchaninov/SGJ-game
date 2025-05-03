extends Node2D

func _ready() -> void:
	if GlobalState.end_result == "bad":
		$EndButton.text = "Лол, ты сдох!!!"
	elif GlobalState.end_result == "good":
		$EndButton.text = "Молодец, рыжая пущена на шарф"
	elif GlobalState.end_result == "romantic":
		$EndButton.text = "И жили они долго и счастливо"

func _on_end_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start_end/StartScene.tscn")
