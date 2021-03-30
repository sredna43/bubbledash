extends KinematicBody2D

var velocity: Vector2 = Vector2()
var direction: Vector2 = Vector2()
var input_dir: Vector3 = Vector3()
var calibrated_zero: Vector2 = Vector2()
export var max_calibration: float = 6
export var speed: int = 150


func _ready():
	reset_position()
	calibrate(true)


func _physics_process(_delta):
	velocity = Vector2.ZERO
	input_dir = Input.get_gravity()
	
	if abs(input_dir.x - calibrated_zero.x) > 0.1:
		velocity.x = -input_dir.x
		
	if abs(input_dir.y - calibrated_zero.y) > 0.1:
		velocity.y = input_dir.y - calibrated_zero.y
		
	velocity.y = clamp(velocity.y, max_calibration - 9.8, 9.8 - max_calibration)
	velocity.x = clamp(velocity.x, max_calibration - 9.8, 9.8 - max_calibration)
	
	get_node("CanvasLayer/Gravity").text = "Input: " + str(input_dir)
	get_node("CanvasLayer/Velocity").text = "Velocity: " + str(velocity)
	get_node("CanvasLayer/y_zero").text = "Calibrated: " + str(calibrated_zero)
	
	velocity = move_and_slide(velocity * speed)
	
	
func calibrate(initial = false, y_only = true, x_only = false):
	if initial:
		calibrated_zero.y = -max_calibration
		calibrated_zero.x = 0
	elif y_only:
		calibrated_zero.y = clamp(Input.get_gravity().y, -max_calibration, max_calibration)
	elif x_only:
		calibrated_zero.x = clamp(Input.get_gravity().x, -max_calibration, max_calibration)
	else:
		calibrated_zero.y = clamp(Input.get_gravity().y, -max_calibration, max_calibration)
		calibrated_zero.x = clamp(Input.get_gravity().x, -max_calibration, max_calibration)
	

func reset_position():
	position = Vector2(540, 960)


func _on_CalibrateYButton_pressed():
	calibrate(false, true)


func _on_RestartButton_pressed():
	reset_position()
