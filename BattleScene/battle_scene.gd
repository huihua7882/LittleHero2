class_name BattleScene

extends Node2D

enum State {
	IDLE,
	WALK,
	PLAYER_TALK,
	ENEMY_TALK,
	PLAYER_INPUT,
	ATTACK_PLAYER,
	ATTACK_ENEMY,
}

@onready var tile_map_2: TileMapLayer = $TileMap2
@onready var player_marker: Marker2D = $PlayerMarker
@onready var enemy_marker: Marker2D = $EnemyMarker
@onready var compute_input: ComputeInput = $CanvasLayer/ComputeInput

const PLAYER_CAMERA = preload("res://Camera/player_camera.tscn")
var enemy_obj : Resource = null
var player : Character = null
var camera : PlayerCamera = null

var enemy : Character = null

#var ask_attack_player : bool = false
#var ask_attack_enemy : bool = false
var ask_player_talk : bool = false
var ask_enemy_talk : bool = false

@onready var battle_enemy: DialogueBase = $CanvasLayer/BattleEnemy
@onready var battle_player: DialogueBase = $CanvasLayer/BattlePlayer

func _ready() -> void:
	Log.d(name, "_ready")
	compute_input.player_attack.connect(func ():
		ask_player_talk = true
	)
	compute_input.enemy_attack.connect(func ():
		ask_enemy_talk = true
	)
	SoundManager.play_bgm_random(true)

func set_data(params := {}) -> void:
	Log.d(name, "params %s" % params)
	compute_input.set_data(params[Game.MAX_DIGIT], params[Game.SYMBOLS])
	player = params[Game.PLAYER].instantiate()
	camera = PLAYER_CAMERA.instantiate()
	player.add_child(camera)
	add_child(player)
	camera.set_map(tile_map_2)
	# Log.d(name, "player %s" % player)
	player.global_position = player_marker.global_position
	player.direction = Vector2(1, 0)
	player.set_collision_layer_value(Game.layer_player, true)
	player.set_collision_layer_value(Game.layer_enemy, false)
	player.hit_box.hit.connect(func (hurt_box: Area2D):
		Log.d(name, "play_sfx %s" % player.animation_player.current_animation)
		SoundManager.play_sfx(player.animation_player.current_animation)
	)
	enemy_obj = params[Game.ENEMY]
	enemy = enemy_obj.instantiate()
	add_child(enemy)
	enemy.global_position = enemy_marker.global_position

func on_state_start(state : State, delta: float) -> void:
	pass

func get_next_state(state : State) -> State:
	match state:
		State.ATTACK_ENEMY:
			if enemy.is_attack_end():
				if player.is_death() and player.is_death_anim_end():
					Game.change_scene_game_over()
					Game.change_scene_game_over({Game.TITLE:"你被魔王打败了\n还需要继续努力修行\n请少侠重新来过吧!!!"})
				elif not enemy.is_death():
					return State.PLAYER_INPUT
		State.ATTACK_PLAYER:
			if player.is_attack_end():
				if enemy.is_death() and enemy.is_death_anim_end():
					Game.change_scene_main({Game.DEATH_OBJ:enemy_obj.resource_path})
				elif not enemy.is_death():
					return State.PLAYER_INPUT
		State.ENEMY_TALK:
			if not battle_enemy.visible:
				return State.ATTACK_ENEMY
		State.PLAYER_TALK:
			if not battle_player.visible:
				return State.ATTACK_PLAYER
		State.PLAYER_INPUT:
			if ask_enemy_talk:
				return State.ENEMY_TALK
			if ask_player_talk:
				return State.PLAYER_TALK
			#if ask_attack_player:
				#return State.ATTACK_PLAYER
			#if ask_attack_enemy:
				#return State.ATTACK_ENEMY
		State.WALK:
			if player.is_idle() and enemy.is_idle():
				return State.PLAYER_INPUT
		State.IDLE:
			if player.is_on_floor():
				return State.WALK
	return state

func on_state_change(old_state : State, new_state : State) -> void:
	Log.d(name, "on_state_change %s -> %s" % [
		State.keys()[old_state],
		State.keys()[new_state],
	])
	match new_state:
		State.ENEMY_TALK:
			ask_enemy_talk = false
			battle_enemy.show_doalogue()
		State.PLAYER_TALK:
			ask_player_talk = false
			battle_player.show_doalogue()
		State.ATTACK_PLAYER:
			player.req_attack()
		State.ATTACK_ENEMY:
			enemy.req_attack()
		State.PLAYER_INPUT:
			compute_input.show()
			compute_input.on_next()
		State.WALK:
			player.req_walk() 
			enemy.req_walk() 
		State.IDLE:
			pass

func on_state_end(state : State, delta: float) -> void:
	match state:
		State.IDLE:
			pass
