extends Control

var story_blocks = {}

func _ready() -> void:
	story_blocks = _read_story()


func _read_story():
	var parser = XMLParser.new()
	var error = parser.open("assets/Story.xml")
	if error != OK:
		print("Error opening XML file", error)
		return
	
	var story_blocks = {}
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
				var speed = 1
				for indx in parser.get_attribute_count():
					var attribute_name = parser.get_attribute_name(indx)
					if attribute_name == "speed":
						speed = parser.get_attribute_value(indx)
				var data = parser.get_node_data()
				story_blocks[current_choose].append({
					"type": "text",
					"text": data,
					"speed": int(speed)
				})
			elif node_name == "select":
				var selections = []
				while parser.read() != ERR_FILE_EOF:
					if parser.get_node_name() == "selection":
						var n_value = parser.get_attribute_value(0)
						parser.read()
						var data_value = parser.get_node_data()
						selections.append({
							"indx": int(n_value),
							"data": data_value
						})
						parser.read()
					else:
						break
				story_blocks[current_choose].append({
					"type": "selections",
					"selections": selections
				})
				
	return story_blocks
				
			
