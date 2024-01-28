extends CanvasLayer

signal emotion_change(type, delta)
signal emotion_score_updated(type, score)
signal end_game()
signal start_game()
signal restart()

@export var amused_bar:ProgressBar
@export var angry_bar:ProgressBar
@export var sad_bar:ProgressBar

@export var min_distance:float = 10
@export var max_distance:float = 200

var gameEnded = false

var emotion_deltas = {
	"sad": 0,
	"angry": 0,
	"amused": 0
}

@export var delta_friction:float = .95
@export var max_delta:float = 3
@export var delta_trigger:float = 2

var bar_dictionary:Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	bar_dictionary["sad"] = sad_bar
	bar_dictionary["angry"] = angry_bar
	bar_dictionary["amused"] = amused_bar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var highest_delta = 0
	var highest_emotion = ""
	for emotion in emotion_deltas:
		emotion_deltas[emotion] *= delta_friction
		
		#print("%s : %s" % [emotion, emotion_deltas[emotion]])
		
		if (absf(emotion_deltas[emotion]) > absf(highest_delta)):
			highest_delta = emotion_deltas[emotion]
			highest_emotion = emotion
	
	if (absf(highest_delta) > delta_trigger):
			emotion_change.emit(highest_emotion, highest_delta)
			
	if !gameEnded && has_player_won():
		gameEnded = true
		end_game.emit()
		$Victory1.emitting = true
		$Victory2.emitting = true
	
func has_player_won():
	return amused_bar.value > sad_bar.value && amused_bar.value > angry_bar.value && amused_bar.value > 55
	
func _score_updated(type, score):
	if (!bar_dictionary.has(type)):
		push_error("No type %s" % type)
	
	_update_bar(bar_dictionary[type], score, type)
		
func _update_bar(bar:ProgressBar, score:float, type:String):
	var prevValue = bar.value
	bar.value = remap(score, max_distance, min_distance, bar.min_value, bar.max_value)
	emotion_deltas[type] = clampf(emotion_deltas[type] + bar.value - prevValue, -max_delta, max_delta)
	emotion_score_updated.emit(type, bar.value)
		

func _on_start_pressed():
	$Title.visible = false
	$EmotionBox.visible = true
	start_game.emit()
	$Menu.visible = false


func _on_credits_pressed():
	$Title.visible = false
	$Menu.visible = false
	$CreditsText.visible = true
	$Credits.visible = true


func _on_back_pressed():
	$Title.visible = true
	$Menu.visible = true
	$CreditsText.visible = false
	$Credits.visible = false
