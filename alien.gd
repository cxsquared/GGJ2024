extends MeshInstance3D

const NUMBER_OF_VERTICES: int = 3
const EXPORT_PATH: String = "res://export_mesh.tres"

@export var base_reference_mesh : NodePath
@export var sad_reference_mesh : NodePath
@export var amused_reference_mesh : NodePath
@export var angry_reference_mesh : NodePath

var vertex_grabbers: Dictionary = {}
var mdt: MeshDataTool = null
var sad_mdt: MeshDataTool = null
var amused_mdt: MeshDataTool = null
var angry_mdt: MeshDataTool = null

@export var max_distance_score:int = 1000
@export var min_distance_score:int = 100

var sad_score:Range
var amused_score:Range
var angry_score:Range

@export var ui:CanvasLayer

@onready var VertexGrabberScene = preload("res://vertex_grabber.tscn")

func _ready() -> void:
	
	#Init emotions
	sad_mdt = MeshDataTool.new()
	var sad_surface_tool = SurfaceTool.new()
	sad_surface_tool.create_from($SadReferenceMesh.mesh, 0)
	var sad_array_mesh = sad_surface_tool.commit()
	sad_mdt.create_from_surface(sad_array_mesh, 0)
	
	amused_mdt = MeshDataTool.new()
	var amused_surface_tool = SurfaceTool.new()
	amused_surface_tool.create_from($AmusedReferenceMesh.mesh, 0)
	var amused_array_mesh = amused_surface_tool.commit()
	amused_mdt.create_from_surface(amused_array_mesh, 0)
	
	angry_mdt = MeshDataTool.new()
	var angry_surface_tool = SurfaceTool.new()
	angry_surface_tool.create_from($AngryReferenceMesh.mesh, 0)
	var angry_array_mesh = angry_surface_tool.commit()
	angry_mdt.create_from_surface(angry_array_mesh, 0)
	
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


func _process(_delta) -> void:
	# Recreate the mesh using the grabbers' positions
	mesh.clear_surfaces()
	mesh.surface_begin(NUMBER_OF_VERTICES)
	for face_idx in range (mdt.get_face_count()):
		for vertex_idx in range(NUMBER_OF_VERTICES):
			var vertex = mdt.get_face_vertex(face_idx, vertex_idx)
			mesh.surface_set_normal(mdt.get_vertex_normal(vertex))
			mesh.surface_set_uv(mdt.get_vertex_uv(vertex))
			mesh.surface_add_vertex(vertex_grabbers[vertex].position)
	mesh.surface_end()
	
	_calculate_emotion()
	

func _calculate_emotion() -> void:
	sad_score.min_value = min_distance_score
	sad_score.max_value = max_distance_score
	
	var sad_distance = 0.
	var angry_distance = 0.
	var amused_distance = 0.
	
	for vertex_idx in range (mdt.get_vertex_count()):
		var curr_vertex = mdt.get_vertex(vertex_idx)
		var sad_vertex = sad_mdt.get_vertex(vertex_idx)
		var angry_vertex = angry_mdt.get_vertex(vertex_idx)
		var amused_vertex = amused_mdt.get_vertex(vertex_idx)
		
		sad_distance += curr_vertex.distance_to(sad_vertex)
		angry_distance += curr_vertex.distance_to(angry_vertex)
		amused_distance += curr_vertex.distance_to(amused_vertex)
		
	sad_score.value = sad_distance

func _export_current_mesh():
	var export_mdt = MeshDataTool.new()
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(mesh, 0)
	var array_mesh = surface_tool.commit()
	ResourceSaver.save(array_mesh, EXPORT_PATH)
