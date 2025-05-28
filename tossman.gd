extends CharacterBody3D

var camera : Camera3D
var headEmpty : Node3D

var baseMouseSens : float = 0.002
var xMouseSens : float
var yMouseSens : float

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const NINETYDEGREESINRADIANS = deg_to_rad(90.0)

var controlsAreLive : bool = true

func _ready() -> void:
	camera = $Camera3D
	headEmpty = $HeadPos
	camera.position = headEmpty.position
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	xMouseSens = -baseMouseSens
	yMouseSens = -baseMouseSens

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("fp_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("fp_strafeleft", "fp_straferight", "fp_forward", "fp_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if controlsAreLive and event is InputEventMouseMotion:
		self.rotate_y(event.relative[0] * yMouseSens)
		camera.rotate_x(event.relative[1] * xMouseSens)
		camera.rotation.x = clamp(camera.rotation.x, -NINETYDEGREESINRADIANS, NINETYDEGREESINRADIANS)

func _on_open_menu() -> void:
	controlsAreLive = false

func _on_close_menu() -> void:
	controlsAreLive = true
