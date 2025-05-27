extends Camera3D

var viewMouseEventPos : Vector2
var targetling : Node3D
var grabHandle : Node3D
var dragging : bool = false
var targetBody : RigidBody3D
var targetHandle : Node3D
var prevStepHandle : Vector3

const CURSORLIFT : Vector3 = Vector3(0,3,0)
const LIFTMASK = 0b00000000_00000000_00000000_00001000
const DRAGGABLEMASK = 0b00000000_00000000_00000000_00000010

const DRAG_P : float = 50.0
const DRAG_D : float = 80.0

func _input(event):
	if event is InputEventMouseButton:
		updateGrabHandle(event)
	if event is InputEventMouse:
		updateMouseTarget(event)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	targetling = $"../GrabTarget"
	grabHandle = $"../GrabHandle"
	targetBody = $"../Grabbable_example"
	targetHandle = targetBody.get_child(2)
	prevStepHandle = targetBody.global_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if dragging:
		var handleVel = targetHandle.global_position - prevStepHandle
		
		var separation : Vector3 = (targetling.global_position) - (targetHandle.global_position)
		var normalizedSeparation : Vector3 = separation.normalized()
		
		var dampedForceVector : Vector3 = (separation * DRAG_P) - (handleVel * DRAG_D)
		targetBody.apply_force(dampedForceVector, targetHandle.global_position - targetBody.global_position)
		
		prevStepHandle = targetHandle.global_position
	

func updateMouseTarget(event) -> void:
	viewMouseEventPos = event.position
	var worldspace = get_world_3d().direct_space_state
	#print(viewMouseEventPos)
	var unitRay : Vector3 =  project_ray_origin(viewMouseEventPos)
	var rayLimit = project_position(viewMouseEventPos, 1000)
	if dragging:
		var result = worldspace.intersect_ray(PhysicsRayQueryParameters3D.create(unitRay, rayLimit, LIFTMASK))
		#print(result)
		if not result.is_empty():
			targetling.position = result["position"]
			
func updateGrabHandle(event) -> void:
	#we have freshly clicked
	viewMouseEventPos = event.position
	var worldspace = get_world_3d().direct_space_state
	#print(viewMouseEventPos)
	var unitRay : Vector3 =  project_ray_origin(viewMouseEventPos)
	var rayLimit = project_position(viewMouseEventPos, 1000)
	
	
	if not dragging and event.pressed:
		var result = worldspace.intersect_ray(PhysicsRayQueryParameters3D.create(unitRay, rayLimit, DRAGGABLEMASK))
		#print(result)
		if not result.is_empty():
			targetling.position = result["position"]
			targetBody = result["collider"]
			targetHandle = targetBody.get_child(2)
			grabHandle.global_position = targetling.global_position
			targetHandle.global_position = grabHandle.global_position
			dragging = true
	elif dragging and not event.pressed:
		dragging = false
		
