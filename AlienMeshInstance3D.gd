extends MeshInstance3D

const NUMBER_OF_VERTICES: int = 3

@onready var VertexGrabberScene = preload("res://vertex_grabber.tscn")

func _ready():
	var mdt = MeshDataTool.new()
	
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from($MeshInstance3D.mesh, 0)
	var array_mesh = surface_tool.commit()

	mdt.create_from_surface(array_mesh, 0)
	
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
