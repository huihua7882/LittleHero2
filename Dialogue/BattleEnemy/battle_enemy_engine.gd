extends DialogueEngine

func _setup() -> void:

	var entry: DialogueEntry = add_text_entry("回答正错误，小子受死吧!")
	entry.set_metadata_data({
		Game.AUTHOR:"怪物",
		Game.AUDIO:preload("res://Assets/Audio/Dialogue/BattleEnemy01.wav"),
	})
	
	#var enemy_entry : DialogueEntry = add_text_entry("!", ENEMY)
	#enemy_entry.set_metadata(Game.AUTHOR, "怪物")

