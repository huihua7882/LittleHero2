extends DialogueEngine

func _setup() -> void:

	var entry: DialogueEntry = add_text_entry("需要完成50道，混合运算的题目，少侠敢挑战吗？")
	entry.set_metadata_data({
		Game.AUTHOR:"怪物",
		Game.AUDIO:preload("res://Assets/Audio/Dialogue/WorldEnemy04.wav"),
	})
	
