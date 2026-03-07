extends CharacterBody2D

@export var speed : float = 200
@export var jump_force : float = 350
@export var gravity : float = 900

@onready var sprite := $Sprite2D

func _ready():
	add_to_group("player")

func _physics_process(delta):

	# gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	# input horizontal
	var direction := Input.get_axis("ui_left", "ui_right")

	velocity.x = direction * speed

	# flip do sprite
	if direction != 0:
		sprite.flip_h = direction < 0

	# pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -jump_force

	move_and_slide()
