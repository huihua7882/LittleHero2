class_name Character

extends CharacterBody2D

enum State {
	IDLE,
	WALK,
	JUMP,
	JUMP_TOP,
	FALL,
	HURT,
	DEATH,
	ATTACK1,
	ATTACK2,
	ATTACK3,
	MAGIC1,
}

const anim_idle : String = "idle"
const anim_walk : String = "walk"
const anim_jump : String = "jump"
const anim_jump_top : String = "jump_top"
const anim_fall : String = "fall"
const anim_hurt : String = "hurt"
const anim_deaht : String = "death"
const anim_attack1 : String = "attack1"
const anim_attack2 : String = "attack2"
const anim_attack3 : String = "attack3"

@onready var node_2d: Node2D = $Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: StateMachine = $StateMachine
@onready var hit_box: HitBox = $Node2D/AnimatedSprite2D/HitBox
@onready var hurt_box: HurtBox = $Node2D/AnimatedSprite2D/HurtBox
# @onready var jump_timer: Timer = $JumpTimer
@onready var ray_cast_2d: RayCast2D = $Node2D/AnimatedSprite2D/RayCast2D
@onready var statistic: Statistic = $Statistic
@onready var health_bar: HealthBar = $HealthBar
@onready var check_player: Area2D = $CheckPlayer
@onready var key_anim: AnimatedSprite2D = $KeyAnim

@export var direction : Vector2 = Vector2(1, 0):
	set(val):
		if direction != val:
			direction = val
			on_direction_change(direction)

var GROUND : Array = [State.IDLE, State.WALK]
const JUMP_SCALE : float = -280.0
const SPEED : float = 160.0
const ACCELERATION : float = SPEED / 0.3
var default_gravity = ProjectSettings.get("physics/2d/default_gravity")

var ask_attack : bool = false
var ask_walk : bool = false

var pending_damage : Damage = null

func _ready() -> void:
	hurt_box.hurt.connect(func (hit_box : Area2D):
		var hit : Character = hit_box.owner
		pending_damage = Damage.new()
		pending_damage.set_hit(hit)
		pending_damage.set_hurt(self)
	)

func req_walk() -> void:
	ask_walk = true

func req_attack() -> void:
	ask_attack = true

func is_idle() -> bool:
	return state_machine.state == State.IDLE and state_machine.frames > 1

func is_death() -> bool:
	return statistic.health <= 0

func is_anim_play_end(anim : String) -> bool:
	if animation_player.current_animation != anim:
		return true
	else:
		return not animation_player.is_playing()

func is_death_anim_end() -> bool:
	return is_anim_play_end(anim_deaht)

func is_attack_end() -> bool:
	#Log.d(name, "frames %s %s" % [
		#state_machine.frames,
		#animation_player.current_animation,
	#])
	return (is_anim_play_end(anim_attack1)
		and is_anim_play_end(anim_attack2)
		and is_anim_play_end(anim_attack3)
		and animation_player.current_animation == anim_idle
		and state_machine.frames > 1
	)

func on_direction_change(direction : Vector2) -> void:
	if not is_node_ready():
		await ready
	if direction.x != 0:
		node_2d.scale.x = direction.x

#func on_box_hit(hurt_box : HurtBox) -> void:
	#SoundManager.play_sfx("Attack")
#
#func on_box_hurt(hit_box : HitBox) -> void:
	#var hit : Character = hit_box.owner
	#pending_damage = Damage.new()
	#pending_damage.set_hit(hit)

func move(speed : float, delta: float) -> void:
	velocity.x = move_toward(velocity.x, speed * direction.x, ACCELERATION * delta)
	velocity.y += default_gravity * delta
	move_and_slide()

func on_state_start(state : State, delta: float) -> void:
	pass

func get_next_state(state : State) -> State:
	match state:
		State.ATTACK3:
			if is_anim_play_end(anim_attack3):
				return State.IDLE
		State.ATTACK2:
			if is_anim_play_end(anim_attack2):
				return State.ATTACK3
		State.ATTACK1:
			if is_anim_play_end(anim_attack1):
				return State.ATTACK2
		State.DEATH:
			if not is_death():
				return State.IDLE
		State.HURT:
			if is_anim_play_end(anim_hurt):
				return State.IDLE
		State.WALK:
			if ray_cast_2d.is_colliding():
				return State.IDLE
		State.IDLE:
			if is_death():
				return State.DEATH
			if pending_damage != null:
				return State.HURT
			if ask_attack:
				return State.ATTACK1
			if ask_walk:
				return State.WALK
	return state

func on_state_change(old_state : State, new_state : State) -> void:
	Log.d(name, "on_state_change %s -> %s" % [
		State.keys()[old_state],
		State.keys()[new_state],
	])
	match new_state:
		State.ATTACK3:
			animation_player.play(anim_attack3)
		State.ATTACK2:
			animation_player.play(anim_attack2)
		State.ATTACK1:
			animation_player.play(anim_attack1)
			ask_attack = false
		State.DEATH:
			animation_player.play(anim_deaht)
		State.HURT:
			animation_player.play(anim_hurt)
			statistic.health -= pending_damage.get_damage()
			pending_damage = null
		State.WALK:
			animation_player.play(anim_walk)
			ask_walk = false
		State.IDLE:
			animation_player.play(anim_idle)

func on_state_end(state : State, delta: float) -> void:
	match state:
		State.WALK:
			move(SPEED, delta)
		State.IDLE:
			move(0, delta)
