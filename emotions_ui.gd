extends CanvasLayer

@export var amused_bar:ProgressBar
@export var angry_bar:ProgressBar
@export var sad_bar:ProgressBar

@export var min_distance:float = 10
@export var max_distance:float = 200

var emotion_deltas = {
	"sad": 0,
	"angry": 0,
	"amused": 0
}

var delta_friction:float = .9
var max_delta:float = 10

signal emotion_score_updated(type, score)

var bar_dictionary:Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	bar_dictionary["sad"] = sad_bar
	bar_dictionary["angry"] = angry_bar
	bar_dictionary["amused"] = amused_bar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for emotion in emotion_deltas:
		emotion_deltas[emotion] *= delta_friction
		print("%s : %s" % [emotion, emotion_deltas[emotion]])
	
func _score_updated(type, score):
	if (!bar_dictionary.has(type)):
		push_error("No type %s" % type)
	
	_update_bar(bar_dictionary[type], score, type)
		
func _update_bar(bar:ProgressBar, score:float, type:String):
	var prevValue = bar.value
	bar.value = remap(score, max_distance, min_distance, bar.min_value, bar.max_value)
	emotion_deltas[type] = clampf(emotion_deltas[type] + bar.value - prevValue, -max_delta, max_delta)
	emotion_score_updated.emit(type, bar.value)
