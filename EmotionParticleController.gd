extends Node

var emotionChangeIndicator = preload("res://emotion_change_indicator.tscn")

var emotions = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func emotion_changed(type, delta):
	if (emotions.has(type)):
		return
		
	var eci = emotionChangeIndicator.instantiate()
	add_child(eci)
	eci.start(type, delta)
	var screenSize = get_viewport().get_visible_rect().size
	
	var rad = deg_to_rad(randi_range(0, 360))
	var distance_from_center = randi_range(150, 400)
	
	eci.position.x = screenSize.x / 2 + (cos(rad) * distance_from_center)
	eci.position.y = screenSize.y / 2 + (sin(rad) * distance_from_center)
	eci.finished.connect(_on_finished)
	
	emotions[type] = eci

func _on_finished(type):
	if (!emotions[type]):
		return
		
	remove_child(emotions[type])
	
	emotions.erase(type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
