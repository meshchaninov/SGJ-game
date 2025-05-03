extends Control

signal StartFight
signal end_signal

var story_blocks = {}
var current_chapter = 1
var selected_chapter = 1
var skip_visible_char = false
var rich_text_label_node: RichTextLabel
var buttons_container: HBoxContainer
var animate_select_buttons: AnimationPlayer
var select_1_button: TextureButton
var select_2_button: TextureButton
var select_3_button: TextureButton
var select_4_button: TextureButton
var fight_button: TextureButton
var end_button: TextureButton

var global_selections = {}
var global_end_result = "happy"
var global_fight_chapter = 1

func _ready() -> void:
	print("Current chapter: ", GlobalState.current_chapter)
	story_blocks = _read_story()
	rich_text_label_node = get_node("ScrollContainer/RichTextLabel")
	buttons_container = get_node("HBoxContainer")
	animate_select_buttons = get_node("AnimateSelectButtons")
	select_1_button = get_node("HBoxContainer/ColorRect/Select 1")
	select_2_button = get_node("HBoxContainer/ColorRect/Select 2")
	select_3_button = get_node("HBoxContainer/ColorRect/Select 3")
	select_4_button = get_node("HBoxContainer/ColorRect/Select 4")
	fight_button = get_node("HBoxContainer/ColorRect/FightButton")
	end_button = get_node("HBoxContainer/ColorRect/EndButton")
	_render_text(GlobalState.current_chapter)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		skip_visible_char = true

func _find_next_elem(arr, prev_indx):
	var prev = null
	for indx in arr.keys():
		if indx == prev_indx:
			return prev
		prev = arr[indx]
	
func _activate_buttons(selections={}, fight=false, end=false):
	animate_select_buttons.play("FadeInButtons")
	select_1_button.hide()
	select_2_button.hide()
	select_3_button.hide()
	select_4_button.hide()
	end_button.hide()
	fight_button.hide()
	if selections != {}:
		for select in selections["selections"]:
			if select["indx"] == 1:
				select_1_button.show()
			elif select["indx"] == 2:
				select_2_button.show()
			elif select["indx"] == 3:
				select_3_button.show()
			elif select["indx"] == 4:
				select_4_button.show()
	if fight:
		fight_button.show()
	if end:
		end_button.show()
	

func _render_text(chapter=1):
	rich_text_label_node.visible_characters = 0
	
	var body = story_blocks[chapter]
	var is_end_button = false
	var is_fight_button = false
	var selections_body = {}
	if GlobalState.chapter_answer != "":
		rich_text_label_node.text += GlobalState.chapter_answer + "\n"
		for i in GlobalState.chapter_answer.length():
			if skip_visible_char:
				rich_text_label_node.visible_characters += len(GlobalState.chapter_answer)
				skip_visible_char = false
				break
			rich_text_label_node.visible_characters += 1
			await get_tree().create_timer(1.0 / float(len(GlobalState.chapter_answer))).timeout
		
	for elem in body:
		if elem["type"] == "text":
			rich_text_label_node.text += elem["text"] + "\n"
			for i in elem["text"].length():
				if skip_visible_char:
					rich_text_label_node.visible_characters += len(elem["text"])
					skip_visible_char = false
					break
				rich_text_label_node.visible_characters += 1
				await get_tree().create_timer(float(elem["speed"]) / float(elem["text"].length())).timeout
		elif elem["type"] == "selections":
			rich_text_label_node.text += "\n"
			for selection in elem["selections"]:
				var select_text = "[code]" + selection["data"] + "[/code]\n"
				rich_text_label_node.text += select_text
				rich_text_label_node.visible_characters += len(selection["data"])
			current_chapter = _find_next_elem(story_blocks, chapter)
			selections_body = elem
	
		elif elem["type"] == "end":
			is_end_button = true
			global_end_result = elem["result"]
		elif elem["type"] == "fight":
			is_fight_button = true
			global_fight_chapter = elem["back_to"]
	rich_text_label_node.visible_characters += 10000 # Woops kostil
	global_selections = selections_body
	_activate_buttons(selections_body, is_fight_button, is_end_button)



func _read_story():
	var parser = XMLParser.new()
	var error = parser.open("assets/Story.xml")
	if error != OK:
		print("Error opening XML file", error)
		return
	
	var current_choose = 0
	while parser.read() != ERR_FILE_EOF:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()
			if node_name == "story":
				parser.read()
			elif node_name == "choose":
				for indx in parser.get_attribute_count():
					var attribute_name = parser.get_attribute_name(indx)
					if attribute_name == "n":
						var n_value = parser.get_attribute_value(indx)
						current_choose = int(n_value)
						story_blocks[current_choose] = []
					
			elif node_name == "text":
				parser.read()
				var speed = "1"
				var backto = null
				for indx in parser.get_attribute_count():
					var attribute_name = parser.get_attribute_name(indx)
					if attribute_name == "speed":
						speed = parser.get_attribute_value(indx)
					elif attribute_name == "backto":
						backto = int(parser.get_attribute_value(indx))
						
				var data = parser.get_node_data()
				story_blocks[current_choose].append({
					"type": "text",
					"text": data,
					"speed": int(speed),
					"backto": backto
				})
			elif node_name == "select":
				var selections = []
				while parser.read() != ERR_FILE_EOF:
					if parser.get_node_name() == "selection":
						var back_to = ""
						var n_value = ""
						var update = ""
						var answer = ""
						for indx in parser.get_attribute_count():
							var attribute_name = parser.get_attribute_name(indx)
							if attribute_name == "backto":
								back_to = parser.get_attribute_value(indx)
							elif attribute_name == "n":
								n_value = parser.get_attribute_value(indx)
							elif attribute_name == "update":
								update = parser.get_attribute_value(indx)
							elif attribute_name == "answer":
								answer = parser.get_attribute_value(indx)
							
						parser.read()
						var data_value = parser.get_node_data()
						selections.append({
							"indx": int(n_value),
							"data": data_value,
							"back_to": int(back_to),
							"update": update,
							"answer": answer,
						})
						parser.read()
					else:
						break
				story_blocks[current_choose].append({
					"type": "selections",
					"selections": selections
				})
			elif node_name == "end":
				var result = "happy"
				for indx in parser.get_attribute_count():
					var attribute_name = parser.get_attribute_name(indx)
					if attribute_name == "result":
						var attribute_value = parser.get_attribute_value(indx)
						if attribute_value == "bad":
							result = "bad"
						elif attribute_value == "happy":
							result = "happy"
						elif attribute_value == "romantic":
							result = "romantic"
				story_blocks[current_choose].append({
					"type": "end",
					"result": result
				})
			elif node_name == "fight":
				var backto = 1
				for indx in parser.get_attribute_count():
					var attribute_name = parser.get_attribute_name(indx)
					if attribute_name == "backto":
						backto = parser.get_attribute_value(indx)
				story_blocks[current_choose].append({
					"type": "fight",
					"back_to": int(backto)
				})
				
	return story_blocks
				
			
func _update_game_state(back_to, max_hp, speed, attack, weaker_fox) -> void:
	GlobalState.current_chapter = back_to
	GlobalState.max_hp += max_hp
	GlobalState.speed += speed
	GlobalState.attack += attack
	GlobalState.fox_speed_level -= weaker_fox

func _select_pressed(indx):
	var max_hp_update = 0
	var speed_update = 0
	var attack_update = 0
	var weaker_fox = 0
	for select in global_selections["selections"]:
		if select["indx"] == indx:
			if select["update"] == "max_hp":
				max_hp_update = 1
			elif select["update"] == "speed":
				speed_update = 1
			elif select["update"] == "attack":
				attack_update = 1
			elif select["update"] == "weaker_fox":
				weaker_fox = 1
			_update_game_state(select["back_to"], max_hp_update, speed_update, attack_update, weaker_fox)
			GlobalState.chapter_answer = select["answer"]
			return
	
func _on_select_1_pressed() -> void:
	_select_pressed(1)
	get_tree().reload_current_scene()


func _on_select_2_pressed() -> void:
	_select_pressed(2)
	get_tree().reload_current_scene()


func _on_select_3_pressed() -> void:
	animate_select_buttons.play("FadeOutButtons")
	_select_pressed(3)
	get_tree().reload_current_scene()


func _on_select_4_pressed() -> void:
	animate_select_buttons.play("FadeOutButtons")
	_select_pressed(4)
	get_tree().reload_current_scene()


func _on_end_button_pressed() -> void:

	GlobalState.end_result = global_end_result
	GlobalState.current_chapter = 1
	get_tree().reload_current_scene()
	end_signal.emit()


func _on_fight_button_pressed() -> void:
	GlobalState.chapter_answer = ""
	GlobalState.fox_speed_level += 1
	GlobalState.current_chapter = global_fight_chapter
	get_tree().reload_current_scene()
	StartFight.emit()
