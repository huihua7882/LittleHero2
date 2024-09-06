extends DialogueEngine

enum OPTION {
	DEFAULT = 0,
	YES = 1,
	NO = 2,
}

func _setup() -> void:

	var entry: DialogueEntry = add_text_entry("需要完成20道，1到10的加减法，少侠敢挑战吗？", OPTION.DEFAULT)
	entry.set_metadata_data({
		Game.AUTHOR:"怪物",
		Game.AUDIO:preload("res://Assets/Audio/Dialogue/WorldEnemy01.wav"),
	})
	var option_id_1 : int = entry.add_option("是的，我要挑战.")
	var option_id_2 : int = entry.add_option("不了，下次再来.")

	var option_id_1_entry : DialogueEntry = add_text_entry("不错哦，少侠，接受你的挑战。", OPTION.YES)
	option_id_1_entry.set_metadata_data({
		Game.AUTHOR:"怪物",
		Game.AUDIO:preload("res://Assets/Audio/Dialogue/WorldEnemy05.wav"),
	})
	entry.set_option_goto_id(option_id_1, option_id_1_entry.get_id())
	var option_id_2_entry : DialogueEntry = add_text_entry("好的，下次再来吧。", OPTION.NO)
	option_id_2_entry.set_metadata_data({
		Game.AUTHOR:"怪物",
		Game.AUDIO:preload("res://Assets/Audio/Dialogue/WorldEnemy06.wav"),
	})
	entry.set_option_goto_id(option_id_2, option_id_2_entry.get_id())
	
	#option_id_1_entry.set_goto_id(entry.get_id())
	#option_id_2_entry.set_goto_id(entry.get_id())
	#
	#add_text_entry("完", OPTION.DEFAULT)
