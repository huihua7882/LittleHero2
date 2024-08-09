class_name ComputeInput

extends Control

signal player_attack()
signal enemy_attack()

const compute_add : String = "+"
const compute_dec : String = "-"
const compute_ride : String = "×"
const compute_except : String = "÷"

@onready var count_1: Label = $VBoxContainer1/HBoxContainer1/Count1
@onready var compute: Label = $VBoxContainer1/HBoxContainer1/Compute
@onready var count_2: Label = $VBoxContainer1/HBoxContainer1/Count2
@onready var line_edit: LineEdit = $VBoxContainer1/HBoxContainer1/LineEdit

@onready var number_0: Button = $VBoxContainer1/HBoxContainer2/VBoxContainer2/Number0
@onready var number_1: Button = $VBoxContainer1/HBoxContainer2/VBoxContainer1/HBoxContainer1/Number1
@onready var number_2: Button = $VBoxContainer1/HBoxContainer2/VBoxContainer1/HBoxContainer1/Number2
@onready var number_3: Button = $VBoxContainer1/HBoxContainer2/VBoxContainer1/HBoxContainer1/Number3
@onready var number_4: Button = $VBoxContainer1/HBoxContainer2/VBoxContainer1/HBoxContainer2/Number4
@onready var number_5: Button = $VBoxContainer1/HBoxContainer2/VBoxContainer1/HBoxContainer2/Number5
@onready var number_6: Button = $VBoxContainer1/HBoxContainer2/VBoxContainer1/HBoxContainer2/Number6
@onready var number_7: Button = $VBoxContainer1/HBoxContainer2/VBoxContainer1/HBoxContainer3/Number7
@onready var number_8: Button = $VBoxContainer1/HBoxContainer2/VBoxContainer1/HBoxContainer3/Number8
@onready var number_9: Button = $VBoxContainer1/HBoxContainer2/VBoxContainer1/HBoxContainer3/Number9

@onready var delete: Button = $VBoxContainer1/HBoxContainer2/VBoxContainer2/Delete
@onready var confirm: Button = $VBoxContainer1/HBoxContainer2/VBoxContainer2/Confirm
@onready var btn_escape: Button = $VBoxContainer1/HBoxContainer1/BtnEscape

var max_digit : int = 0
var symbols : Array = []

func _ready() -> void:
	Log.d(name, "_ready")
	compute.text = compute_add
	
	number_0.button_up.connect(on_number.bind(0))
	number_1.button_up.connect(on_number.bind(1))
	number_2.button_up.connect(on_number.bind(2))
	number_3.button_up.connect(on_number.bind(3))
	number_4.button_up.connect(on_number.bind(4))
	number_5.button_up.connect(on_number.bind(5))
	number_6.button_up.connect(on_number.bind(6))
	number_7.button_up.connect(on_number.bind(7))
	number_8.button_up.connect(on_number.bind(8))
	number_9.button_up.connect(on_number.bind(9))
	
	delete.button_up.connect(on_delete)
	confirm.button_up.connect(on_confirm)
	btn_escape.pressed.connect(func ():
		Game.change_scene_main()
	)
	SoundManager.setup_ui_sounds(self, number_1)

func set_data(n : int, s : Array) -> void:
	max_digit = n
	symbols = s
	Log.d(name, "max_digit %s symbols %s" % [max_digit, symbols.size()])
	# on_next()

func on_number(number : int) -> void:
	Log.d(name, "on_number %s" % number)
	line_edit.text = line_edit.text + str(number)

func on_delete() -> void:
	line_edit.text = line_edit.text.erase(line_edit.text.length()-1)

func on_confirm() -> void:
	var count1 : float = float(count_1.text)
	var count2 : float = float(count_2.text)
	var result : String = ""
	Log.d(name, "%s" % (compute.text == "+"))
	match compute.text:
		"+":
			result = str(count1 + count2)
		"-":
			result = str(count1 - count2)
		"×":
			result = str(count1 * count2)
		"÷":
			result = str(count1 / count2)

	Log.d(name, "%s %s %s = %s %s" % [
		count1,
		compute.text,
		count2,
		result,
		line_edit.text,
	])
	if result == line_edit.text:
		on_player()
	else:
		on_enemy()

func on_player() -> void:
	hide()
	player_attack.emit()

func on_enemy() -> void:
	hide()
	enemy_attack.emit()

func get_symbol() -> int:
	var symbol : int = randi_range(0, 3)
	if symbol in symbols:
		return symbol + 1
	return get_symbol()

func on_next() -> void:
	line_edit.text = ""
	var symbol : int = get_symbol()
	match symbol:
		1:
			compute.text = compute_add
			var digit1 : int = randi_range(0, max_digit)
			var digit2 : int = randi_range(0, max_digit)
			count_1.text = str(digit1)
			count_2.text = str(digit2)
			if digit1 + digit2 > max_digit:
				on_next()
		2:
			compute.text = compute_dec
			var digit1 : int = randi_range(0, max_digit)
			var digit2 : int = randi_range(0, max_digit)
			if digit1 > digit2:
				count_1.text = str(digit1)
				count_2.text = str(digit2)
			else:
				count_1.text = str(digit2)
				count_2.text = str(digit1)
		3:
			compute.text = compute_ride
			var digit1 : int = randi_range(1, 9)
			var digit2 : int = randi_range(1, 9)
			count_1.text = str(digit1)
			count_2.text = str(digit2)
		4:
			compute.text = compute_except
