extends MeshInstance3D

const NUMBER_OF_VERTICES: int = 3
const EXPORT_PATH: String = "res://export_mesh.tres"

signal score_updated(type:String, score:float)

var vertex_grabbers: Dictionary = {}
var mdt: MeshDataTool = null

var emotion_meshes = {}
var emotion_mdts = {}
var emotion_verts = {}

@onready var VertexGrabberScene = preload("res://vertex_grabber.tscn")

func _ready() -> void:
	#Init emotions
	emotion_meshes = {
		"sad": $SadReferenceMesh.mesh,
		"angry": $AngryReferenceMesh.mesh,
		"amused": $AmusedReferenceMesh.mesh
	}
	
	# Init the MeshDataTool with the reference geometry
	mdt = MeshDataTool.new()
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from($ReferenceMesh.mesh, 0)
	var array_mesh = surface_tool.commit()
	mdt.create_from_surface(array_mesh, 0)
	
	# Copy the texture from the reference mesh
	material_override = mdt.get_material()
	
	# Create the initial mesh. This should be the same as the reference geometry
	mesh.surface_begin(NUMBER_OF_VERTICES)
	for face_idx in range (mdt.get_face_count()):
		for vertex_idx in range(NUMBER_OF_VERTICES):
			var vertex = mdt.get_face_vertex(face_idx, vertex_idx)
			mesh.surface_set_normal(mdt.get_vertex_normal(vertex))
			mesh.surface_set_uv(mdt.get_vertex_uv(vertex))
			mesh.surface_add_vertex(mdt.get_vertex(vertex))
	mesh.surface_end()
	
	# Add the vertex grabbers
	for i in range(mdt.get_vertex_count()):
		var vertex_grabber = VertexGrabberScene.instantiate()
		vertex_grabber.position = mdt.get_vertex(i)
		add_child(vertex_grabber)
		vertex_grabbers[i] = vertex_grabber
	
	for emotion in emotion_meshes:
		var emotion_mdt = MeshDataTool.new()
		var emotion_surface_tool = SurfaceTool.new()
		emotion_surface_tool.create_from(emotion_meshes[emotion], 0)
		var emotion_array_mesh = emotion_surface_tool.commit()
		emotion_mdt.create_from_surface(emotion_array_mesh, 0)
		emotion_mdts[emotion] = emotion_mdt
		
	for emotion in emotion_mdts:
		emotion_verts[emotion] = get_vertex_data(emotion_mdts[emotion])

func _process(_delta) -> void:
	# Recreate the mesh using the grabbers' positions
	mesh.clear_surfaces()
	mesh.surface_begin(NUMBER_OF_VERTICES)
	var data = get_curr_vertex_data()
	for index in data:
		mesh.surface_set_normal(index[0])
		mesh.surface_set_uv(index[1])
		mesh.surface_add_vertex(index[2])

	mesh.surface_end()
	
	_calculate_emotion()

func _calculate_emotion() -> void:
	var emotion_scores = {}
	
	for emotion in emotion_mdts:
		emotion_scores[emotion] = 0.

	var current_vert_data = get_curr_vertex_data()
	for i in range(current_vert_data.size()):
		var current_vertex = current_vert_data[i][2]
			
		for emotion in emotion_verts:
			var emotion_vertex = emotion_verts[emotion][i][2]
			emotion_scores[emotion] += current_vertex.distance_to(emotion_vertex)
	
	for emotion in emotion_scores:
		print("%s : %s" % [emotion, emotion_scores[emotion]])
		score_updated.emit(emotion, emotion_scores[emotion])

func _export_current_mesh():
	var export_surface_tool = SurfaceTool.new()
	export_surface_tool.create_from(mesh, 0)
	var export_array_mesh = export_surface_tool.commit()
	ResourceSaver.save(export_array_mesh, EXPORT_PATH, ResourceSaver.FLAG_COMPRESS)
	
func get_curr_vertex_data() -> Array:
	var data = []
	for face_idx in range (mdt.get_face_count()):
		for vertex_face_idx in range(NUMBER_OF_VERTICES):	
			var vertex_idx = mdt.get_face_vertex(face_idx, vertex_face_idx)
			data.push_back([mdt.get_vertex_normal(vertex_idx), mdt.get_vertex_uv(vertex_idx), vertex_grabbers[vertex_idx].position])
			
	return data
	
func get_vertex_data(input:MeshDataTool) -> Array:
	var data = []
	for face_idx in range (input.get_face_count()):
		for vertex_face_idx in range(NUMBER_OF_VERTICES):	
			var vertex_idx = input.get_face_vertex(face_idx, vertex_face_idx)
			data.push_back([input.get_vertex_normal(vertex_idx), input.get_vertex_uv(vertex_idx), input.get_vertex(vertex_idx)])
			
	return data
