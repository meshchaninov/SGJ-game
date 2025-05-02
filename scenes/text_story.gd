extends Control

signal StartFight

var story_blocks = {}
var current_chapter = 1
var selected_chapter = 1
var skip_visible_char = false
var rich_text_label_node: RichTextLabel
var buttons_container: HBoxContainer
var animate_select_buttons: AnimationPlayer
var select_1_button: Button
var select_2_button: Button
var select_3_button: Button
var select_4_button: Button

func _ready() -> void:
	story_blocks = _read_story()
	print(story_blocks)
	rich_text_label_node = get_node("ScrollContainer/RichTextLabel")
	buttons_container = get_node("HBoxContainer")
	animate_select_buttons = get_node("AnimateSelectButtons")
	select_1_button = get_node("HBoxContainer/ColorRect/Select 1")
	select_2_button = get_node("HBoxContainer/ColorRect/Select 2")
	select_3_button = get_node("HBoxContainer/ColorRect/Select 3")
	select_4_button = get_node("HBoxContainer/ColorRect/Select 4")
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
	
func _activate_buttons(selections):
	animate_select_buttons.play("FadeInButtons")
	select_1_button.hide()
	select_2_button.hide()
	select_3_button.hide()
	select_4_button.hide()
	for select in selections["selections"]:
		if select["indx"] == 1:
			select_1_button.show()
		elif select["indx"] == 2:
			select_2_button.show()
		elif select["indx"] == 3:
			select_3_button.show()
		elif select["indx"] == 4:
			select_4_button.show()	

func _render_text(chapter=1) -> void:
	
	rich_text_label_node.visible_characters = 0
	
	var body = story_blocks[chapter]
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
			rich_text_label_node.text += "\n"
			current_chapter = _find_next_elem(story_blocks, chapter)
			_activate_buttons(elem)
			return



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
				if parser.get_node_type() == XMLParser.NODE_TEXT:
					print()
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
						for indx in parser.get_attribute_count():
							var attribute_name = parser.get_attribute_name(indx)
							if attribute_name == "backto":
								back_to = parser.get_attribute_value(indx)
							elif attribute_name == "n":
								n_value = parser.get_attribute_value(indx)
							elif attribute_name == "update":
								update = parser.get_attribute_value(indx)
						parser.read()
						var data_value = parser.get_node_data()
						selections.append({
							"indx": int(n_value),
							"data": data_value,
							"back_to": int(back_to)
						})
						parser.read()
					else:
						break
				story_blocks[current_choose].append({
					"type": "selections",
					"selections": selections
				})
				
				
	return story_blocks
				
			


func _on_select_1_pressed() -> void:
	animate_select_buttons.play("FadeOutButtons")
	get_tree().reload_current_scene()


func _on_select_2_pressed() -> void:
	animate_select_buttons.play("FadeOutButtons")
	get_tree().reload_current_scene()


func _on_select_3_pressed() -> void:
	animate_select_buttons.play("FadeOutButtons")
	get_tree().reload_current_scene()


func _on_select_4_pressed() -> void:
	animate_select_buttons.play("FadeOutButtons")
	get_tree().reload_current_scene()
