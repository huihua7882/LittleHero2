class_name Rocker

extends TouchScreenButton

const DRAG_RADIUS := 18.0

# 多指，只相应第一个手指
var finger_index := -1
var rest_pos : Vector2 = Vector2.ZERO
var drag_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	Log.d(name, "_ready")
	rest_pos = global_position

func _input(event: InputEvent) -> void:
	# 按下抬起
	var st := event as InputEventScreenTouch
	# 移动
	var sd := event as InputEventScreenDrag
	if st:
		if st.pressed and finger_index == -1: # 按下
			var global_pos := st.position * get_canvas_transform()
			var local_pos := global_pos * get_global_transform()  # to_local(global_pos)
			var rect := Rect2(Vector2.ZERO, texture_normal.get_size())
			#Log.d(name, "按下 %s %s %s %s" % [
				#st.position,
				#global_pos,
				#local_pos,
				#rect,
			#])
			if rect.has_point(local_pos): # 是区域内
				Log.d(name, "按下")
				finger_index = st.index
				drag_offset = global_pos - global_position
		elif not st.pressed and st.index == finger_index: # 抬起
			Log.d(name, "抬起")
			finger_index = -1
			global_position = rest_pos
			Input.action_release("ui_left")
			Input.action_release("ui_right")
			Input.action_release("ui_up")
			Input.action_release("ui_down")
	if sd and sd.index == finger_index:
		Log.d(name, "移动")
		var wish_pos : Vector2 = sd.position * get_canvas_transform() - drag_offset
		var movement : Vector2 = (wish_pos - rest_pos).limit_length(DRAG_RADIUS)
		global_position = rest_pos + movement
		movement /= DRAG_RADIUS
		Log.d(name, "%s" % movement)
		if movement.x > 0:
			Input.action_release("ui_left")
			Input.action_press("ui_right", 1)
		elif movement.x < 0:
			Input.action_release("ui_right")
			Input.action_press("ui_left", 1)
		if movement.y > 0:
			Input.action_release("ui_up")
			Input.action_press("ui_down", 1)
		elif movement.y < 0:
			Input.action_release("ui_down")
			Input.action_press("ui_up", 1)
