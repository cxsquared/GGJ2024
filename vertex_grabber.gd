extends Area3D

@export var individual_grab:bool
@export_range(0, 1, 0.1) var drag_range: float

@export var smudge: bool = false
@export_range(0, 1, 0.01) var smudge_range: float
@export_range(0, 1, 0.1) var selected_exit_range: float

@export var group_grab: bool = false
@export_range(0, 2, 0.1) var group_grab_radius:float

var initial_position: Vector3 = Vector3(0, 0, 0)
var mouse_pressed: bool = false
var hovered: bool = false
var selected: bool = false

func _ready() -> void:
	initial_position = position

func _process(_delta) -> void:	
	if smudge && hovered && mouse_pressed && !selected:
		var relative_mouse_position = get_relative_mouse_position()
		var distance = (relative_mouse_position - initial_position).length()
		if  distance < smudge_range:
			print("selected")
			selected = true
		
	if selected:
		var new_position = get_relative_mouse_position()
		var distance = (new_position - initial_position).length()
		# If we are out of range, set the position to the max range in the same direction
		if distance > drag_range:
			position = initial_position + drag_range * (new_position - initial_position).normalized()
		else:
			position = new_position
		
		if smudge && distance > selected_exit_range:
			selected = false
		

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			mouse_pressed = true
			if hovered:
				selected = true
				
			if group_grab:
				var distance = (get_relative_mouse_position() - initial_position).length()
				if distance < group_grab_radius:
					selected = true
					
		elif event.is_released():
			mouse_pressed = false
			selected = false
			$HoverIndicator.visible = hovered
		
		
func _on_mouse_entered():
	if individual_grab:
		if !mouse_pressed:
			$HoverIndicator.visible = true
		
		hovered = true


func _on_mouse_exited():
	if !selected:
		$HoverIndicator.visible = false
		
	hovered = false
	
func get_relative_mouse_position():
	var mouse_position = get_viewport().get_mouse_position()
	var camera = get_viewport().get_camera_3d()
	var origin = camera.project_ray_origin(mouse_position)
	return Vector3(origin.x, position.y, origin.z)
	
