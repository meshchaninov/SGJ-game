extends Node2D

func _ready() -> void:
	if GlobalState.end_result == "bad":
		if GlobalState.fox_meeting_number == 0:
			$Kolobok.texture = load("res://assets/sprites/kolobok/kolobok_dead.png")
		else: $Kolobok.texture = load("res://assets/sprites/kolobok/Kolob_implant_dead.png")
		$EndButton.text = "Лол, ты сдох!!!"
	elif GlobalState.end_result == "good":
		$Kolobok.texture = load("res://assets/sprites/kolobok/Kolob_implant.png")
		$EndButton.text = "Молодец, рыжая пущена на шарф"
	elif GlobalState.end_result == "romantic":
		$EndButton.text = "И жили они долго и счастливо"

func _on_end_button_pressed() -> void:
	if GlobalState.end_result != "bad":
		get_tree().change_scene_to_file("res://scenes/TextStory.tscn")
	else: get_tree().change_scene_to_file("res://scenes/start_end/StartScene.tscn")
