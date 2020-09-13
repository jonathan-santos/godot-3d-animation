extends KinematicBody

const SPEED := 15
const ACCELERATION := 20.0
var velocity: Vector3
var direction: Vector3
onready var body := $Body

onready var camera: Spatial = get_viewport().get_camera()

func _process(delta):
	move(delta)
	switch_animations()
	rotate_body()
		
func move(delta):
	direction = Vector3()
	
	if Input.is_action_pressed("move_forward"):
		direction -= camera.transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += camera.transform.basis.z
		
	if Input.is_action_pressed("move_left"):
		direction -= camera.transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += camera.transform.basis.x
	
	velocity = velocity.linear_interpolate(direction * SPEED, ACCELERATION * delta)
	velocity = move_and_slide(velocity, Vector3.UP)
	
func switch_animations():
	if direction.length() > 0:
		$AnimationPlayer.play("Moving")
	else:
		$AnimationPlayer.play("Idle")
	
func rotate_body():
	var movement_dir_angle = atan2(velocity.x, velocity.z)
	var new_body_rot = body.rotation
	new_body_rot.y = lerp_angle(body.rotation.y, movement_dir_angle, 0.2)
	body.rotation = new_body_rot
