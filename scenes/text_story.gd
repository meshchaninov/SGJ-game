extends Control

var story_blocks = {}
var current_chapter = 1
var skip_visible_char = false
var rich_text_label_node: RichTextLabel

func _ready() -> void:
	story_blocks = _read_story()
	print(story_blocks)
	rich_text_label_node = get_node("ScrollContainer/RichTextLabel")
	_render_text()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		skip_visible_char = true



func _render_text(start_with=1) -> void:
	rich_text_label_node.visible_characters = 0
	
	for indx in story_blocks.keys():
		print(indx)
		var body = story_blocks[indx]
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
				current_chapter = indx + 1
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
						for indx in parser.get_attribute_count():
							var attribute_name = parser.get_attribute_name(indx)
							if attribute_name == "backto":
								back_to = parser.get_attribute_value(indx)
							elif attribute_name == "n":
								n_value = parser.get_attribute_value(indx)
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
				
			
