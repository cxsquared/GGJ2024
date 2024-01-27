extends CanvasLayer

@export var amused_bar:ProgressBar
@export var angry_bar:ProgressBar
@export var sad_bar:ProgressBar

@export var min_distance:float = 10
@export var max_distance:float = 200

var bar_dictionary:Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	bar_dictionary["sad"] = sad_bar
	bar_dictionary["angry"] = angry_bar
	bar_dictionary["amused"] = amused_bar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _score_updated(type, score):
	if (!bar_dictionary.has(type)):
		push_error("No type %s" % type)
	
	_update_bar(bar_dictionary[type], score)
		
func _update_bar(bar:ProgressBar, score:float):
	bar.value = remap(score, max_distance, min_distance, bar.min_value, bar.max_value)
