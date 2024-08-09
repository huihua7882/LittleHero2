class_name World

extends Node2D

const PLAYER = preload("res://Character/Player/player.tscn")

@onready var tile_map: TileMap = $TileMap
@onready var pause: Pause = $CanvasLayer/Pause
@onready var marker_2d: Marker2D = $Marker2D
@onready var marker_2d_1: Marker2D = $Marker2D1
@onready var marker_2d_2: Marker2D = $Marker2D2
@onready var marker_2d_3: Marker2D = $Marker2D3
@onready var marker_2d_4: Marker2D = $Marker2D4
@onready var dialogue_base: DialogueBase = $CanvasLayer/DialogueBase

var player: Player = null

func _ready() -> void:
	player = PLAYER.instantiate()
	add_child(player)
	# Log.d(name, "Game.player_position %s" % Game.player_position)
	if Game.player_position == Vector2.ZERO:
		Game.player_position = marker_2d.global_position
	player.player.global_position = Game.player_position
	player.camera.set_map(tile_map)
	for key : String in Game.enemys.keys():
		var item : Dictionary = Game.enemys[key]
		var enemmy := item[Game.RESOURCE].instantiate() as Character
		if enemmy and not item[Game.DEATH]:
			add_child(enemmy)
			if key == Game.FLYINGEYE:
				enemmy.global_position = marker_2d_1.global_position
			elif key == Game.GOBLIN:
				enemmy.global_position = marker_2d_2.global_position
			elif key == Game.MUSHROOM:
				enemmy.global_position = marker_2d_3.global_position
			elif key == Game.SKELETON:
				enemmy.global_position = marker_2d_4.global_position
			enemmy.check_player.body_entered.connect(func (body: Node):
				enemmy.key_anim.show()
				dialogue_base.dialogue_gdscript = item[Game.DIALOGUE]
			)
			enemmy.check_player.body_exited.connect(func (body: Node):
				enemmy.key_anim.hide()
			)
			item[Game.PLAYER] = player.PLAYER
			enemmy.hurt_box.hurt.connect(func (hit_box : Area2D):
				Game.player_position = player.player.position
				Game.change_scene_battle(item)
			)
	
	SoundManager.play_bgm_random(true)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		pause.show_pause()
	elif event.is_action_pressed("dialogue"):
		dialogue_base.show_doalogue()

func is_victory() -> bool:
	var victory : bool = true
	for key in Game.enemys.keys():
		var item : Dictionary = Game.enemys[key]
		if not item[Game.DEATH]:
			victory = false
	return victory

func _physics_process(delta: float) -> void:
	if is_victory():
		Game.change_scene_game_over({Game.TITLE:"恭喜少侠打败大魔王\n真的太棒了\n深林也恢复了往日的宁静"})
