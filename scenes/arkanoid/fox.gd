extends Area2D
class_name Fox

@export var MainScene: Arkanoid
@export var KolobokfScene: Kolobok

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init() -> void:
	$FoxVisual/First.visible = false
	$FoxVisual/Second.visible = false
	if GlobalState.fox_meeting_number == 1:
		$FoxVisual/First.visible = true
	else:
		$FoxVisual/Second.visible = true
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

signal hit

#func _on_body_entered(body: Node2D) -> void:
	#print('name by fox: ' + body.name)
	#if body.name == 'Kolobok': 
		#body.push = true
		#body.hit()
		#MainScene.damage()
		# Должно быть в пуле
	#if body.name == 'Basic': 
		#body.hit()
		#MainScene.hit.emit()


#func _on_area_entered(body: Area2D) -> void:
	#if body.name == 'Basic': 
		#body.hit()
		#MainScene.hit_fox.emit()


func _on_body_entered(body: Node2D) -> void:
	if body.name == 'Kolobok': 
		body.push = true
		body.hit()
		MainScene.damage()
