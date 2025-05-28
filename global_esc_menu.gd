extends CanvasLayer

var inMenu : bool = false
signal openMenu
signal closeMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escmenu"):
		if not inMenu:
			inMenu = true
			openMenu.emit()
			self.visible = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			inMenu = false
			closeMenu.emit()
			self.visible = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
