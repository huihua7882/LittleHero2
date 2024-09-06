#class_name Game

extends CanvasLayer

const layer_environment : int = 1
const layer_player : int = 2
const layer_enemy : int = 3
const layer_hurt : int = 4

const MAX_DIGIT = "max_digit"
const SYMBOLS = "symbols"
const PLAYER = "player"
const ENEMY = "enemy"

@onready var color_rect: ColorRect = $ColorRect

const DEATH_OBJ : String = "death_obj"
#var death_enemy : Array = []
const DEATH : String = "death"
var player_position : Vector2 = Vector2.ZERO

const TITLE : String = "title"
const AUTHOR : String = "author"
const AUDIO : String = "audio"
const POSITION : String = "position"
const FLYINGEYE : String = "FlyingEye"
const GOBLIN : String = "Goblin"
const MUSHROOM : String = "Mushroom"
const SKELETON : String = "Skeleton"
const RESOURCE : String = "resource"
const DIALOGUE : String = "dialogue"

var enemys : Dictionary = {
	FLYINGEYE : {
		POSITION : Vector2.ZERO,
		RESOURCE : preload("res://Character/FlyingEye/flying_eye.tscn"),
		DEATH : false,
		DIALOGUE : preload("res://Dialogue/WorldEnemy/world_enemy_engine_01.gd"),
		MAX_DIGIT:10,
		SYMBOLS:[0, 1],
		ENEMY:preload("res://Character/FlyingEye/flying_eye.tscn"),
	},
	GOBLIN : {
		POSITION : Vector2.ZERO,
		RESOURCE : preload("res://Character/Goblin/goblin.tscn"),
		DEATH : false,
		DIALOGUE : preload("res://Dialogue/WorldEnemy/world_enemy_engine_02.gd"),
		MAX_DIGIT:100,
		SYMBOLS:[0, 1],
		ENEMY:preload("res://Character/Goblin/goblin.tscn"),
	},
	MUSHROOM : {
		POSITION : Vector2.ZERO,
		RESOURCE : preload("res://Character/Mushroom/mushroom.tscn"),
		DEATH : false,
		DIALOGUE : preload("res://Dialogue/WorldEnemy/world_enemy_engine_03.gd"),
		MAX_DIGIT:9,
		SYMBOLS:[2],
		ENEMY:preload("res://Character/Mushroom/mushroom.tscn"),
	},
	SKELETON : {
		POSITION : Vector2.ZERO,
		RESOURCE : preload("res://Character/Skeleton/skeleton.tscn"),
		DEATH : false,
		DIALOGUE : preload("res://Dialogue/WorldEnemy/world_enemy_engine_04.gd"),
		MAX_DIGIT:100,
		SYMBOLS:[0, 1, 2],
		ENEMY:preload("res://Character/Skeleton/skeleton.tscn"),
	},
}

func _ready() -> void:
	pass

func change_scene_setting(params := {}) -> void:
	var tree : SceneTree = await change_scene("res://UI/Setting/setting.tscn")

func change_scene_battle(params := {}) -> void:
	var tree : SceneTree = await change_scene("res://BattleScene/battle_scene.tscn")
	if Game.PLAYER in params:
		Log.d(name, "player %s" % params[Game.PLAYER])
	tree.current_scene.set_data(params)

func change_scene_about_game(params := {}) -> void:
	var tree : SceneTree = await change_scene("res://UI/About/about_game.tscn")

func change_scene_title(params := {}) -> void:
	var tree : SceneTree = await change_scene("res://UI/Title/title_scene.tscn")

func change_scene_game_over(params := {}) -> void:
	var tree : SceneTree = await change_scene("res://UI/GameOver/game_over.tscn")
	if Game.TITLE in params:
		tree.current_scene.set_title(params[Game.TITLE])

func change_scene_prelude(params := {}) -> void:
	var tree : SceneTree = await change_scene("res://Dialogue/Prelude/prelude.tscn")
	tree.current_scene.show_doalogue()

func change_scene_main(params := {}) -> void:
	var tree : SceneTree = await change_scene("res://Map/world.tscn")
	# Log.d(name, "change_scene_main %s" % params)
	if DEATH_OBJ in params:
		for key in enemys.keys():
			var item : Dictionary = enemys[key]
			if params[DEATH_OBJ] == item[RESOURCE].resource_path:
				item[Game.DEATH] = true

func save_player() -> void:
	pass

func restore_main() -> void:
	pass

func change_scene(path: String) -> SceneTree:
	var tree : SceneTree = get_tree()
	tree.paused = true

	var duration : float = 0.3
	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS) # 该参数控制不允许多个动画同时执行
	tween.tween_property(color_rect, "color:a", 1, duration)
	await tween.finished

	tree.change_scene_to_file(path)
	await tree.tree_changed

	tree.paused = false
	tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "color:a", 0, duration)
	return tree
