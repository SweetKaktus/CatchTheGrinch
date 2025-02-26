extends CharacterBody2D

const GRAVITY = 300
var speed : float = 13000.0
var max_speed: float = 250.0
var dir : int = 1
var is_flipped : bool = false
var jump_force : float = 150
var lerp_weight : float = 0.1
var is_jumping = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	handle_movement(delta)
	pass

func _process(delta: float) -> void:
	var last_dir = 0
	if dir != 0:
		last_dir = dir
	if last_dir == 1:
		animated_sprite_2d.flip_h = false
	elif last_dir == -1:
		animated_sprite_2d.flip_h = true
	if abs(velocity.x) > 20 and not is_jumping:
		animated_sprite_2d.play("Walk")
	elif is_on_floor():
		animated_sprite_2d.play("Idle")
	


func _input(event: InputEvent) -> void:
	dir = int(Input.get_axis("left", "right"))
		
func jump() -> void:
	is_jumping = true
	animated_sprite_2d.play("Jump")
	velocity.y -= jump_force

func handle_movement(delta: float) -> void:
	velocity.y += GRAVITY * delta
	clamp(velocity.x, -max_speed, max_speed)
	print(velocity.x)
	if is_on_floor():
		is_jumping = false
	if dir:
		velocity.x = lerp(0.0, dir * speed * delta, 0.7)
	else: 
		velocity.x = move_toward(velocity.x, 0.0, speed)
	if Input.is_action_just_pressed("jump") and not is_jumping:
		jump()
	move_and_slide()
