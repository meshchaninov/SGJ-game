extends Node

# Вот тут описываем все состояния, которые переносятся между сценами
# https://forum.godotengine.org/t/transfering-a-variable-over-to-another-scene/33407/5
# Это синглтон, по сути. Обращаться так: GlobalState.field

# тут правила нейминга переменных 
# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#naming-conventions

## Fox
# Повышается после каждого выбора в "стори" режиме чтобы не делать лишних условий
var fox_meeting_number = 0
# Тоже повышается после каждого выбора
var fox_speed_level = 0
var fox_hp = 600
const FOX_HP_STAGES = [500, 300, 0]

## Player
var max_hp = 2
var speed = 1
var attack = 1

## Text Story
var current_chapter = 1
var chapter_answer = ""

## Концовка "happy", "bad", "romantic"
var end_result = "happy"

# Подрубается при геймовере
func reset():
	fox_meeting_number = 0
	fox_speed_level = 0
	max_hp = 2
	speed = 1
	attack = 1
	current_chapter = 1
	end_result = "happy"
	
