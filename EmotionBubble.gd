extends TextureRect

@export var sad_bubble: Texture2D
@export var angry_bubble: Texture2D
@export var amused_bubble: Texture2D

var scores = {
	"sad": 0,
	"angry": 0,
	"amused": 0
}

var current_type = "sad"

# Called when the node enters the scene tree for the first time.
func _ready():
	texture = sad_bubble

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var highest_score = -1
	var highest_type = "sad"
	
	for score in scores:
		if scores[score] > highest_score:
			highest_score = scores[score]
			highest_type = score
	
	if (highest_type != current_type):
		current_type = highest_type
		match(current_type):
			"sad": 
				texture = sad_bubble
			"angry":
				texture = angry_bubble
			"amused":
				texture = amused_bubble
	
func update_emotion(type, score):
	scores[type] = score

