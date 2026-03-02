extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var max_health:float = 100 # Vitalidade do crisol, na lore
@export var max_mana:float = 100; # Vigor de batalha, na lore
# Vai ser float, por precaução ^
@export var attack_scene:PackedScene

var current_health: float
var current_mana: float

func ready() -> void:
	current_health = max_health
	current_mana = max_mana
	add_to_group("player")
	
func die() -> void:
	# Adicionar função aqui que ativa lógica pós morte.
	queue_free() # Some
	
func take_damage(damage_taken: float) -> void:
	current_health = current_health - damage_taken
	if current_health <= 0:
		current_health = 0
		die()
		
func attack() -> void:
	print("ataque!")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left")
		
	
	
	
	

	
	
