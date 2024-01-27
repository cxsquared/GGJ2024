extends Area3D

@export_range(0, 1, 0.1) var drag_range: float

var initial_position: Vector3 = Vector3(0, 0, 0)
var mouse_pressed: bool = false
var hovered: bool = false
var selected: bool = false

func _ready() -> void:
	initial_position = position


func _process(_delta) -> void:
	if selected:
		var mouse_position = get_viewport().get_mouse_position()
		var camera = get_viewport().get_camera_3d()
		var origin = camera.project_ray_origin(mouse_position)
		var new_position = Vector3(origin.x, position.y, origin.z)
		# If we are out of range, set the position to the max range in the same direction
		if (new_position - initial_position).length() > drag_range:
			position = initial_position + drag_range * (new_position - initial_position).normalized()
		else:
			position = new_position


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			mouse_pressed = true
			if hovered:
				selected = true
		elif event.is_released():
			mouse_pressed = false
			selected = false
			$HoverIndicator.visible = hovered
		
		
func _on_mouse_entered():
	if !mouse_pressed:
		$HoverIndicator.visible = true
	hovered = true


func _on_mouse_exited():
	if !selected:
		$HoverIndicator.visible = false
	hovered = false
