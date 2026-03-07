extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
	
enum ActionState {NONE, ATTACK, SHOOT, INTERACT} 
enum LocomotionState {IDLE, WALK, FALL, JUMP, RUN, DASH} # Não sei se run vai ser usado, mas coloquei aqui mesmo assim
enum LifeState {ALIVE, DEAD} 
enum BodyState {STAND, CROUCHED, LOOK_UP}

var DASHING: bool

@export var max_health: float = 100 # Vitalidade do crisol, na lore
@export var max_mana: float = 100; # Vigor de batalha, na lore
@export var attack_slash: PackedScene
@onready var attack_origin := $AttackOrigin/Marker2D
@onready var collision := $Collision
@onready var sprite := $Visual

var current_health: float
var current_mana: float
var action_state: ActionState = ActionState.NONE
var locomotion_state: LocomotionState = LocomotionState.IDLE
var life_state: LifeState = LifeState.ALIVE
var body_state: BodyState = BodyState.STAND
	
func ready() -> void:
	current_health = max_health
	current_mana = max_mana
	add_to_group("player") # Não é pra ser usado de qualquer jeito. Usar só quando necessário
	
func _physics_process(delta: float) -> void:
	if self.life_state == LifeState.DEAD:
		fall_if_need(delta)
		move_and_slide()
		return
	
	update_animation()	
	handle_crouch()
	fall_if_need(delta)
	process_walk()
	process_jump()
	move_and_slide()
	
func handle_crouch():
	if Input.is_action_pressed("ui_down"):
		self.body_state = BodyState.CROUCHED
		collision.shape.size.y = 60
	else:
		collision.shape.size.y = 120
		self.body_state = BodyState.STAND
	
func take_damage(damage_taken: float) -> void:
	current_health -= damage_taken
	if current_health <= 0:
		current_health = 0
		self.die()
	# hud.update_health(current_health) # Algo assim vai existir no futuro
	
func spend_mana(mana_spent: float) -> void:
	current_mana -= mana_spent
	if current_mana <= 0:
		current_mana = 0
	# hud.update_mana(current_mana) # Algo assim vai existir no futuro
		
func die() -> void:
	# Adicionar função aqui que ativa lógica pós morte.
	queue_free() # Some
	
func attack() -> void:
	var slash = attack_slash.instantiate()
	attack_origin.add_child(slash)
	slash.transform = Transform2D.IDENTITY
	
func _unhandled_input(event) -> void:
	if event.is_action_pressed("attack"):
		attack()
		
func process_walk():
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		self.velocity.x = direction * SPEED
	else:
		self.velocity.x = move_toward(velocity.x, 0, SPEED)
		
func process_jump():
	if Input.is_action_just_pressed("ui_accept") and self.is_on_floor():
		velocity.y = JUMP_VELOCITY
	
func fall_if_need(delta: float):
	if not self.is_on_floor():
		self.velocity += get_gravity() * delta
		
func update_animation():
	sprite.update(action_state, locomotion_state, life_state, body_state)
	
	
	
	

	
	
