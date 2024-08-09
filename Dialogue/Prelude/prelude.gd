class_name Prelude

extends DialogueBase

func _ready() -> void:
	super._ready()

func __on_dialogue_finished() -> void:
	Game.change_scene_main()
