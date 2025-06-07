extends CharacterBody3D

var camera : Camera3D
var headEmpty : Node3D

var baseMouseSens : float = 0.002
var xMouseSens : float
var yMouseSens : float

var input_dir : Vector2
var direction : Vector3

const ACCEL = 40.0
const SPEED = 5.0
const FRIC = 6.0
const AIR_ACCEL = 8.5
const AIR_FRIC = 0.2
const AIR_SPEED = 5.0
const JUMP_VELOCITY = 4.5
const NINETYDEGREESINRADIANS = deg_to_rad(90.0)

var base_FOV = 75

var controlsAreLive : bool = true
var currentfric : float
var currentaccel : float
var acceltimesdelta : float
var frictimesdelta : float

var speedbox : RichTextLabel

func _ready() -> void:
	camera = $Camera3D
	headEmpty = $HeadPos
	speedbox = $"../HUD/Control/RichTextLabel"
	camera.position = headEmpty.position
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	xMouseSens = -baseMouseSens
	yMouseSens = -baseMouseSens
	
	GlobalSignalBus.connect("onJumppadTouched", applyJumpPadForce)


func _physics_process(delta: float) -> void:
	
	# Control Input Chunk
	if controlsAreLive:
		if Input.is_action_pressed("fp_jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		input_dir = Input.get_vector("fp_strafeleft", "fp_straferight", "fp_forward", "fp_backward")
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		currentfric = AIR_FRIC
		currentaccel = AIR_ACCEL
	else:
		currentfric = FRIC
		currentaccel = ACCEL
	
	acceltimesdelta = currentaccel * delta
	frictimesdelta = currentfric * delta
	velocity.x = velocity.x + (direction.x * acceltimesdelta) - (velocity.x * frictimesdelta)
	velocity.z = velocity.z + (direction.z * acceltimesdelta) - (velocity.z * frictimesdelta)

	move_and_slide()

func _process(delta: float) -> void:
	speedbox.text = str(velocity.length()).pad_decimals(3)
	camera.fov = base_FOV + velocity.length()
	
func _input(event: InputEvent) -> void:
	if controlsAreLive and event is InputEventMouseMotion:
		self.rotate_y(event.relative[0] * yMouseSens)
		camera.rotate_x(event.relative[1] * xMouseSens)
		camera.rotation.x = clamp(camera.rotation.x, -NINETYDEGREESINRADIANS, NINETYDEGREESINRADIANS)
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()
		
func _on_open_menu() -> void:
	controlsAreLive = false

func _on_close_menu() -> void:
	controlsAreLive = true

func applyJumpPadForce():
	print("Player getting forced by jumppad")
	velocity.y = 10.0
