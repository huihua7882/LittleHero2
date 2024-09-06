class_name DialogueBase

extends Control

@export var dialogue_gdscript : GDScript = null:
	set(val):
		if dialogue_gdscript != val:
			dialogue_gdscript = val
			if dialogue_gdscript:
				dialogue_engine = dialogue_gdscript.new()
				dialogue_engine.dialogue_started.connect(__on_dialogue_started)
				dialogue_engine.dialogue_continued.connect(__on_dialogue_continued)
				#dialogue_engine.entry_visited.connect(__on_entry_visited)
				#dialogue_engine.dialogue_about_to_finish.connect(__on_dialogue_about_to_finish)
				dialogue_engine.dialogue_finished.connect(__on_dialogue_finished)
				dialogue_engine.dialogue_cancelled.connect(__on_dialogue_cancelled)

var dialogue_engine : DialogueEngine = null

@onready var label: Label = $ColorRect/HBoxContainer/Label
@onready var rich_text_label: RichTextLabel = $ColorRect/HBoxContainer/RichTextLabel
@onready var h_box_container: HBoxContainer = $ColorRect/HBoxContainer/RichTextLabel/HBoxContainer

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

#var tween : Tween = null
var buttons : Array[Button] = []
var can_input : bool = true

func _ready() -> void:
	Log.d(name, "_ready")
	SoundManager.stop()
	rich_text_label.set_use_bbcode(true)
	rich_text_label.set_fit_content(true)
	SoundManager.setup_ui_sounds(self)
	visibility_changed.connect(on_visibility_changed)
	on_visibility_changed()

func on_visibility_changed() -> void:
	Log.d(name, "visibility_changed %s" % visible)
	# set_process_input(visible)
	if visible:
		Log.d(name, "advance")
		dialogue_engine.advance()

func show_doalogue() -> void:
	if not visible and dialogue_gdscript:
		show()

func hide_doalogue() -> void:
	hide()

func _gui_input(event: InputEvent) -> void:
	if visible:
		if can_input:
			if (event.is_action_pressed(&"attack")):
				Log.d(name, "advance")
				dialogue_engine.advance()
				accept_event()

func __on_dialogue_started() -> void:
	Log.d(name, "__on_dialogue_started")

func __on_dialogue_continued(p_dialogue_entry : DialogueEntry) -> void:
	Log.d(name, "__on_dialogue_continued")
	var author := p_dialogue_entry.get_metadata(Game.AUTHOR) as String
	if author:
		label.text = author + ":"
	var audio := p_dialogue_entry.get_metadata(Game.AUDIO) as Resource
	if audio:
		if audio_stream_player.playing:
			audio_stream_player.stop()
		audio_stream_player.stream = audio
		audio_stream_player.finished.connect(func ():
			pass
		)
		audio_stream_player.play()
	rich_text_label.text = p_dialogue_entry.get_text()
	
	can_input = not p_dialogue_entry.has_options()
	Log.d(name, "can_input %s" % can_input)
	if p_dialogue_entry.has_options():
		for option_id : int in range(0, p_dialogue_entry.get_option_count()):
			var option_text : String = p_dialogue_entry.get_option_text(option_id)
			set_button(option_text, option_id)

#func __on_entry_visited(p_dialogue_entry : DialogueEntry) -> void:
	#Log.d(name, "__on_entry_visited")
	#set_process_input(not p_dialogue_entry.has_options())
	#can_input = not p_dialogue_entry.has_options()
	#Log.d(name, "can_input %s" % can_input)
	#if p_dialogue_entry.has_options():
		#for option_id : int in range(0, p_dialogue_entry.get_option_count()):
			#var option_text : String = p_dialogue_entry.get_option_text(option_id)
			#set_button(option_text, option_id)
	#else:
		#dialogue_engine.advance()

func set_button(option_text : String, option_id : int) -> void:
	var button : Button = Button.new()
	h_box_container.add_child(button)
	button.set_text(option_text)
	if option_id == 0:
		button.grab_focus()
	button.pressed.connect(on_button_option.bind(option_id))
	buttons.push_back(button)

func on_button_option(option_id : int) -> void:
	Log.d(name, "on_button_option %s" % option_id)
	for item : Button in buttons:
		item.set_disabled(true)
		h_box_container.remove_child(item)
	buttons.clear()

	var current_entry : DialogueEntry = dialogue_engine.get_current_entry()
	current_entry.choose_option(option_id)
	Log.d(name, "advance")
	dialogue_engine.advance()
	# set_process_input(true)

func __on_dialogue_about_to_finish() -> void:
	Log.d(name, "__on_dialogue_about_to_finish")

func __on_dialogue_finished() -> void:
	Log.d(name, "__on_dialogue_finished %s" % dialogue_engine.get_current_entry_id())
	hide_doalogue()

func __on_dialogue_cancelled() -> void:
	Log.d(name, "__on_dialogue_cancelled")
	# talk = false
	# hide_doalogue()
