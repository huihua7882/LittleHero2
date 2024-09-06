class_name Player

extends Node2D

@onready var jump_timer: Timer = $JumpTimer

const PLAYER = preload("res://Character/Blue/blue.tscn")
const PLAYER_CAMERA = preload("res://Camera/player_camera.tscn")
var player : Character = null
var camera : PlayerCamera = null

var input_direction : Vector2 = Vector2.ZERO
var ask_attack : bool = false

func _ready() -> void:
	player = PLAYER.instantiate()
	camera = PLAYER_CAMERA.instantiate()
	player.add_child(camera)
	add_child(player)
	player.owner = owner
	player.set_collision_layer_value(Game.layer_player, true)
	player.set_collision_layer_value(Game.layer_enemy, false)
	#hit_box.hit.connect(func (hurt_box : HurtBox):
		#Game.change_scene_battle()
	#)
	player.state_machine.enable = false
	player.direction = Vector2(1, 0)
	player.check_player.monitoring = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if player.is_on_floor():
			jump_timer.start()
	if event.is_action_released("ui_accept"):
		jump_timer.stop()
		if player.velocity.y < Character.JUMP_SCALE / 3.0:
			player.velocity.y = Character.JUMP_SCALE / 3.0
	if event.is_action_pressed("attack"):
		# if state_machine.state in GROUND:
		ask_attack = true

func get_input_direction() -> Vector2:
	return Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)

func move(speed : float, delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, speed * input_direction.x, Character.ACCELERATION * delta)
	player.velocity.y += player.default_gravity * delta
	player.move_and_slide()

func on_state_start(state : Character.State, delta: float) -> void:
	input_direction = get_input_direction()
	if input_direction and player.direction != input_direction:
		if player.is_anim_play_end(player.anim_attack1):
			player.direction = input_direction

func get_next_state(state : Character.State) -> Character.State:
	match state:
		Character.State.ATTACK1:
			if player.is_anim_play_end(player.anim_attack1):
				return Character.State.IDLE
		Character.State.JUMP:
			if ask_attack:
				return Character.State.ATTACK1
			if player.velocity.y >= 0:
				return Character.State.JUMP_TOP
		Character.State.JUMP_TOP:
			if ask_attack:
				return Character.State.ATTACK1
			if player.is_on_floor():
				return Character.State.IDLE
			if player.is_anim_play_end(player.anim_jump_top):
				return Character.State.FALL
		Character.State.FALL:
			if ask_attack:
				return Character.State.ATTACK1
			if player.is_on_floor():
				return Character.State.IDLE
		Character.State.WALK:
			if ask_attack:
				return Character.State.ATTACK1
			if jump_timer.time_left > 0:
				return Character.State.JUMP
			if not input_direction and player.velocity.x == 0:
				return Character.State.IDLE
		Character.State.IDLE:
			if ask_attack:
				return Character.State.ATTACK1
			if jump_timer.time_left > 0:
				return Character.State.JUMP
			if input_direction:
				return Character.State.WALK
	return state

func on_state_change(old_state : Character.State, new_state : Character.State) -> void:
	Log.d(name, "on_state_change %s -> %s" % [
		Character.State.keys()[old_state],
		Character.State.keys()[new_state],
	])
	match new_state:
		Character.State.ATTACK1:
			player.animation_player.play(player.anim_attack1)
			ask_attack = false
			# SoundManager.play_sfx(player.anim_attack1)
			get_tree().create_timer(0.2).timeout.connect(func ():
				SoundManager.play_sfx(player.anim_attack1)
			)
		Character.State.JUMP:
			player.animation_player.play(player.anim_jump)
			player.velocity.y += Character.JUMP_SCALE
			jump_timer.stop()
			SoundManager.play_sfx(player.anim_jump)
		Character.State.JUMP_TOP:
			player.animation_player.play(player.anim_jump_top)
		Character.State.FALL:
			player.animation_player.play(player.anim_fall)
		Character.State.WALK:
			player.animation_player.play(player.anim_walk)
		Character.State.IDLE:
			player.animation_player.play(player.anim_idle)

func on_state_end(state : Character.State, delta: float) -> void:
	match state:
		Character.State.ATTACK1:
			if player.is_on_floor():
				move(0, delta)
			else:
				move(Character.SPEED, delta)
		Character.State.JUMP:
			move(Character.SPEED, delta)
		Character.State.JUMP_TOP:
			move(Character.SPEED, delta)
		Character.State.FALL:
			move(Character.SPEED, delta)
		Character.State.WALK:
			move(Character.SPEED, delta)
		Character.State.IDLE:
			move(0, delta)
