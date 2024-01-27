extends MeshInstance3D



# Called when the node enters the scene tree for the first time.
func _ready():
	# Begin draw.
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)

	# Prepare attributes for add_vertex.
	mesh.surface_set_normal(Vector3(0, 0, 1))
	mesh.surface_set_uv(Vector2(0, 0))
	# Call last for each vertex, adds the above attributes.
	mesh.surface_add_vertex(Vector3(-1, -1, 0))

	mesh.surface_set_normal(Vector3(0, 0, 1))
	mesh.surface_set_uv(Vector2(0, 1))
	mesh.surface_add_vertex(Vector3(-1, 1, 0))

	mesh.surface_set_normal(Vector3(0, 0, 1))
	mesh.surface_set_uv(Vector2(1, 1))
	mesh.surface_add_vertex(Vector3(1, 1, 0))
	
	# Prepare attributes for add_vertex.
	mesh.surface_set_normal(Vector3(0, 0, 1))
	mesh.surface_set_uv(Vector2(1, 0))
	# Call last for each vertex, adds the above attributes.
	mesh.surface_add_vertex(Vector3(1, -1, 0))

	# End drawing.
	mesh.surface_end()


#func _process(delta):
#
#	# Clean up before drawing.
#	mesh.clear_surfaces()
#
#	# Begin draw.
#	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
#
#	# Draw mesh.
#		# Prepare attributes for add_vertex.
#	mesh.surface_set_normal(Vector3(0, 0, 1))
#	mesh.surface_set_uv(Vector2(0, 0))
#	# Call last for each vertex, adds the above attributes.
#	mesh.surface_add_vertex(Vector3(-1, -1, 0))
#
#	mesh.surface_set_normal(Vector3(0, 0, 1))
#	mesh.surface_set_uv(Vector2(0, 1))
#	mesh.surface_add_vertex(Vector3(-1, 1, 0))
#
#	mesh.surface_set_normal(Vector3(0, 0, 1))
#	mesh.surface_set_uv(Vector2(1, 1))
#	mesh.surface_add_vertex(Vector3(1, 1, 0))
#
#	# Prepare attributes for add_vertex.
#	mesh.surface_set_normal(Vector3(0, 0, 1))
#	mesh.surface_set_uv(Vector2(0, 0))
#	# Call last for each vertex, adds the above attributes.
#	mesh.surface_add_vertex(Vector3(-1 *  randf_range(.5, 1.), -1 *  randf_range(.5, 1.), 0))
#
#	mesh.surface_set_normal(Vector3(0, 0, 1))
#	mesh.surface_set_uv(Vector2(1, 1))
#	mesh.surface_add_vertex(Vector3(1 * randf_range(.5, 1.), 1 *  randf_range(.5, 1.), 0))
#
#	mesh.surface_set_normal(Vector3(0, 0, 1))
#	mesh.surface_set_uv(Vector2(1, 0))
#	mesh.surface_add_vertex(Vector3(1 *  randf_range(.5, 1.), -1 *  randf_range(.5, 1.), 0))
#
#	# End drawing.
#	mesh.surface_end()
#	pass
