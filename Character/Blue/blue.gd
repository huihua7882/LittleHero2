class_name Blue

extends Character

func _ready() -> void:
	super._ready()

#func get_input_direction() -> Vector2:
	#return Vector2(
		#Input.get_axis("ui_left", "ui_right"),
		#Input.get_axis("ui_up", "ui_down")
	#)

#func on_state_start(state : State, delta: float) -> void:
	#input_direction = get_input_direction()
	#if input_direction and direction != input_direction:
		#if is_anim_play_end(anim_attack1):
			#direction = input_direction

#func get_next_state(state : State) -> State:
	#match state:
		#State.ATTACK1:
			#if is_anim_play_end(anim_attack1):
				#return State.IDLE
		#State.JUMP:
			#if ask_attack:
				#return State.ATTACK1
			#if velocity.y >= 0:
				#return State.JUMP_TOP
		#State.JUMP_TOP:
			#if ask_attack:
				#return State.ATTACK1
			#if is_on_floor():
				#return State.IDLE
			#if is_anim_play_end(anim_jump_top):
				#return State.FALL
		#State.FALL:
			#if ask_attack:
				#return State.ATTACK1
			#if is_on_floor():
				#return State.IDLE
		#State.WALK:
			#if ask_attack:
				#return State.ATTACK1
			#if jump_timer.time_left > 0:
				#return State.JUMP
			#if not input_direction and velocity.x == 0:
				#return State.IDLE
		#State.IDLE:
			#if ask_attack:
				#return State.ATTACK1
			#if jump_timer.time_left > 0:
				#return State.JUMP
			#if input_direction:
				#return State.WALK
	#return state

#func on_state_change(old_state : State, new_state : State) -> void:
	#Log.d(name, "on_state_change %s -> %s" % [
		#State.keys()[old_state],
		#State.keys()[new_state],
	#])
	#match new_state:
		#State.ATTACK1:
			#animation_player.play(anim_attack1)
			#ask_attack = false
		#State.JUMP:
			#animation_player.play(anim_jump)
			#velocity.y += JUMP_SCALE
			#jump_timer.stop()
		#State.JUMP_TOP:
			#animation_player.play(anim_jump_top)
		#State.FALL:
			#animation_player.play(anim_fall)
		#State.WALK:
			#animation_player.play(anim_walk)
		#State.IDLE:
			#animation_player.play(anim_idle)

#func on_state_end(state : State, delta: float) -> void:
	#match state:
		#State.ATTACK1:
			#if is_on_floor():
				#move(0, delta)
			#else:
				#move(SPEED, delta)
		#State.JUMP:
			#move(SPEED, delta)
		#State.JUMP_TOP:
			#move(SPEED, delta)
		#State.FALL:
			#move(SPEED, delta)
		#State.WALK:
			#move(SPEED, delta)
		#State.IDLE:
			#move(0, delta)
