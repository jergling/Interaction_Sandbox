extends Node3D
@onready var hitRay : RayCast3D = $RayCast3D
@onready var hitBox : Node3D = $CastHitMark
@onready var holdBox : Node3D = $HoldTarget

const DRAG_P : float = 50.0
const DRAG_D : float = 80.0

var hitPos : Vector3 = Vector3(0,0,0)
var dragging = false
var grabbedObject : Node3D

var holdDepth : float = 0.0

var targetHandle : Node3D
var grabhandle
var prevStepHandle : Vector3 = Vector3(0,0,0)
var handleVel : Vector3 = Vector3(0,0,0)

var separationVector : Vector3 

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		hitPos = hitRay.get_collision_point()
		hitBox.global_position = hitPos
		holdBox.global_position = hitPos
		dragging = true
		
		grabbedObject = hitRay.get_collider()
		if grabbedObject != null:
			
			holdDepth = (hitPos - self.position).length()
			print("Grabbed object: " + str(grabbedObject) + " at distance " + str(holdDepth))
			dragging = true
		
	elif event.is_action_released("fire"):
		print("Released object: " + str(grabbedObject))
		grabbedObject = null
		dragging = false

func _physics_process(delta: float) -> void:
	
	if dragging:
		handleVel = grabbedObject.global_position - prevStepHandle
		separationVector = holdBox.global_position - grabbedObject.global_position
		#print(separationVector.length())
		grabbedObject.apply_force(separationVector * 2)
		var dampedForceVector : Vector3 = (separationVector * DRAG_P) - (handleVel * DRAG_D)
		grabbedObject.apply_force(dampedForceVector)
		
		prevStepHandle = grabbedObject.global_position
