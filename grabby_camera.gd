extends Camera3D

var viewMouseEventPos : Vector2
var targetling : Node3D
var grabHandle : Node3D
var dragging : bool = false
var targetBody : RigidBody3D

func _input(event):
	if event is InputEventMouse:
		updateMouseTarget(event)
	if event is InputEventMouseButton:
		updateGrabHandle(event)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	targetling = $"../GrabTarget"
	grabHandle = $"../GrabHandle"
	targetBody = $"../Grabbable_example"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var direction : Vector3 = targetling.global_position - targetBody.global_position
	#var normalizedDirection : Vector3 = direction.normalized()
	targetBody.apply_central_force(direction * 5.0)
	

func updateMouseTarget(event) -> void:
	viewMouseEventPos = event.position
	var worldspace = get_world_3d().direct_space_state
	#print(viewMouseEventPos)
	var unitRay : Vector3 =  project_ray_origin(viewMouseEventPos)
	var rayLimit = project_position(viewMouseEventPos, 1000)
	var result = worldspace.intersect_ray(PhysicsRayQueryParameters3D.create(unitRay, rayLimit))
	#print(result)
	if not result.is_empty():
		targetling.position = result["position"]

func updateGrabHandle(event) -> void:
	#we have freshly clicked
	if not dragging and event.pressed:
		grabHandle.global_position = targetling.global_position
		targetBody.add_child(grabHandle)
		dragging = true
	elif dragging and not event.pressed:
		targetBody.remove_child(grabHandle)
		dragging = false
		
