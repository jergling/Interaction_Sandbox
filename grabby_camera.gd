extends Camera3D

var viewMouseEventPos : Vector2
var targetling : Node3D
var grabHandle : Node3D
var dragging : bool = false
var targetBody : RigidBody3D
const CURSORLIFT : Vector3 = Vector3(0,3,0)
const LIFTMASK = 0b00000000_00000000_00000000_00001000
const DRAGGABLEMASK = 0b00000000_00000000_00000000_00000010

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
	if dragging:
		var targetHandle = targetBody.get_child(2)
		var separation : Vector3 = (targetling.global_position) - (targetHandle.global_position)
		print("target global pos:" + str(targetling.global_position))
		print("handle global pos:" + str(targetHandle.global_position))
		print("target-handle separation:" + str(separation))
		#var normalizedDirection : Vector3 = direction.normalized()
		targetBody.apply_force(separation * 15.0, targetHandle.global_position - targetBody.global_position)
		#targetBody.apply_central_force(separation * 15.0)
	

func updateMouseTarget(event) -> void:
	viewMouseEventPos = event.position
	var worldspace = get_world_3d().direct_space_state
	#print(viewMouseEventPos)
	var unitRay : Vector3 =  project_ray_origin(viewMouseEventPos)
	var rayLimit = project_position(viewMouseEventPos, 1000)
	if not dragging:
		var result = worldspace.intersect_ray(PhysicsRayQueryParameters3D.create(unitRay, rayLimit, DRAGGABLEMASK))
		#print(result)
		if not result.is_empty():
			targetling.position = result["position"]
	else:
		var result = worldspace.intersect_ray(PhysicsRayQueryParameters3D.create(unitRay, rayLimit, LIFTMASK))
		#print(result)
		if not result.is_empty():
			targetling.position = result["position"]
			
func updateGrabHandle(event) -> void:
	#we have freshly clicked
	if not dragging and event.pressed:
		grabHandle.global_position = targetling.global_position
		targetBody.get_child(2).global_position = grabHandle.global_position
		dragging = true
	elif dragging and not event.pressed:
		targetBody.remove_child(grabHandle)
		dragging = false
		
