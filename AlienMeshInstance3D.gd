extends MeshInstance3D

@onready var VertexGrabberScene = preload("res://vertex_grabber.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var mdt = MeshDataTool.new()
	mdt.create_from_surface($ReferenceGeometry/Cube.mesh, 0)
	# mesh.surface_set_material(0, $ReferenceGeometry/Cube.mesh.surface_get_material())
	# Begin draw.
	mesh.surface_begin(3)
	print(mdt.get_vertex_count())
	for i in range(mdt.get_vertex_count()):
		var vertex_grabber = VertexGrabberScene.instantiate()
		vertex_grabber.position = mdt.get_vertex(i)
		add_child(vertex_grabber)
		
		mesh.surface_set_normal(mdt.get_vertex_normal(i))
		mesh.surface_set_uv(mdt.get_vertex_uv(i))
		mesh.surface_add_vertex(mdt.get_vertex(i))
		
	# End drawing.
	mesh.surface_end()
