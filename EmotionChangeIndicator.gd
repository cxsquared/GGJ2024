extends Node2D

signal finished(type)

@export var sad_image:Texture
@export var angry_image:Texture
@export var amused_image:Texture

@export var up:Texture
@export var down:Texture

@onready var emotionParticle = $EmotionParticle
@onready var directionParticle = $DirectionParticle

var is_finished = false
var is_started = false

var type:String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start(emotion, delta):
	match(emotion):
		"sad":
			emotionParticle.texture = sad_image
		"angry":
			emotionParticle.texture = angry_image
		"amused":
			emotionParticle.texture = amused_image
	
	if (delta > 0):
		directionParticle.texture = up
	else:
		directionParticle.texture = down
		
	type = emotion
		
	emotionParticle.restart()
	directionParticle.restart()
	is_started = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (is_started && !is_finished && !$EmotionParticle.emitting):
		is_finished = true
		finished.emit(type)
