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
const MAX_FOX_HP = 100
var fox_hp = MAX_FOX_HP
const FOX_HP_STAGES = [70, 30, 0]

## Player
var max_hp = 2
var speed = 1
var attack = 1

## Text Story
var current_chapter = 1
var chapter_answer = ""
var last_fight = false
var disable_happy_ending = false
var romantic = 0

## Концовка "happy", "bad", "romantic"
var end_result = "happy"

# Подрубается при геймовере
func reset():
	fox_meeting_number = 0
	fox_speed_level = 0
	fox_hp = MAX_FOX_HP
	max_hp = 2
	speed = 1
	attack = 1
	current_chapter = 1
	chapter_answer = ""
	last_fight = false
	disable_happy_ending = false
	romantic = 0
	end_result = "happy"
	
