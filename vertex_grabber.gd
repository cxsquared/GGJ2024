extends Area3D

@export_range(0, 1, 0.1) var drag_range: float

var initial_position: Vector3 = Vector3(0, 0, 0)
var hovered: bool = false
var selected: bool = false

func _ready() -> void:
	initial_position = position


func _process(delta) -> void:
	if selected and (position - initial_position).length() < drag_range:
		# TODO: This doesn't work correctly
		var mouse_position = get_viewport().get_mouse_position()
		var camera = get_viewport().get_camera_3d()
		var origin = camera.project_ray_origin(mouse_position)
		position = Vector3(origin.x, origin.y, origin.z)


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
