class_name HitBox

extends Area2D

signal hit(hurt_box: Area2D)

func _ready() -> void:
	Log.d(owner.name, "_ready")
	area_entered.connect(on_area_entered)

func on_area_entered(hurt_box: Area2D) -> void:
	# Log.d(name, "%s %s" % [self, hurt_box])
	# Log.d(name, "%s %s" % [self.owner, hurt_box.owner])
	if owner != hurt_box.owner:
		hit.emit(hurt_box)
		hurt_box.hurt.emit(self)
