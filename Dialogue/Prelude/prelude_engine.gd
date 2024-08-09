extends DialogueEngine

func _setup() -> void:
	# add_text_entry("[rainbow freq=1.0 sat=0.4 val=0.8]你好，少侠，欢迎来到游戏世界。[/rainbow]") # 彩虹颜色滚动
	# add_text_entry("[shake rate=20.0 level=5 connected=1]你好，少侠，欢迎来到游戏世界。[/shake]") # 字体抖动
	# add_text_entry("你好，[b]少侠[/b]，欢迎来到游戏世界。") # 加粗
	# add_text_entry("你好，[i]少侠[/i]，欢迎来到游戏世界。") # 倾斜
	# add_text_entry("你好，[color=#FF0000]少侠[/color]，欢迎来到游戏世界。") # 改变字体颜色
	var entry: DialogueEntry = add_text_entry("你好，少侠，欢迎来到大森林。")
	entry.set_metadata_data({
		Game.AUTHOR:"旁白",
		Game.AUDIO:preload("res://Assets/Audio/Dialogue/Prelude01.wav"),
	})
	entry = add_text_entry("那么请开始你的冒险吧。")
	entry.set_metadata_data({
		Game.AUTHOR:"旁白",
		Game.AUDIO:preload("res://Assets/Audio/Dialogue/Prelude02.wav"),
	})
