extends Area3D

var hovered = false
var selected = false


func _process(delta):
	if selected:
		# TODO: This doesn't work correctly. Can only move the grabbers in one direction.
		var mouse_position = get_viewport().get_mouse_position()
		var camera = get_viewport().get_camera_3d()
		var origin = camera.project_ray_origin(mouse_position)
		position = Vector3(origin.x, origin.y, position.z)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			if hovered:
				selected = true
		elif event.is_released():
			selected = false
		
		
func _on_mouse_entered():
	hovered = true


func _on_mouse_exited():
	hovered = false
