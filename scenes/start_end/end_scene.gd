extends Node2D

signal end_game

func _on_end_button_pressed() -> void:
	end_game.emit()
