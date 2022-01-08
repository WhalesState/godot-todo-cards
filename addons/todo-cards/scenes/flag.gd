tool
extends Button

var stylebox = preload('res://addons/todo-cards/assets/flag.stylebox').duplicate() as StyleBoxFlat
var color := Color.white

onready var todo_cards = get_parent().todo_cards

func _ready()-> void:
	connect('pressed', self, '_on_flag_pressed')
#<END>

func update_color(_col: Color)-> void:
	stylebox.bg_color = _col
#<END>

func set_styles()-> void:
	update_color(color)
	var _styles := ['normal', 'hover', 'pressed']
	for st in _styles:
		add_stylebox_override(st, stylebox)
#<END>

func _on_flag_pressed()-> void:
	var _popup = todo_cards.flag_popup
	_popup.current_flag = self
	var _rect := Rect2(get_viewport().get_mouse_position(), _popup.rect_size)
	_popup.popup(_rect)
#<END>


