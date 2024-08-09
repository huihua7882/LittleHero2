class_name HurtBox

extends Area2D

signal hurt(hit_box : Area2D)

func _ready() -> void:
	Log.d("%s %s" % [owner.name, name], "_ready")
