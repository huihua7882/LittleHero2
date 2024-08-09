#class_name Log

extends Node

func _init() -> void:
	d(name, "_init")

func _ready() -> void:
	d(name, "_ready")

func d(tag : String, text : String) -> void:
	print("[%s]debug %s %s" % [
		Engine.get_physics_frames(),
		tag,
		text,
	])
	push_warning("[%s]debug %s %s" % [
		Engine.get_physics_frames(),
		tag,
		text,
	])

func e(tag : String, text : String) -> void:
	printerr("[%s]debug %s %s" % [
		Engine.get_physics_frames(),
		tag,
		text,
	])
	push_error("[%s]debug %s %s" % [
		Engine.get_physics_frames(),
		tag,
		text,
	])

