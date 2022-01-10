tool
extends WindowDialog

var current_flag : Button
var stylebox = preload('res://addons/todo-cards/assets/flag.stylebox') as StyleBoxFlat

onready var flags_grid = get_node('VBox/FlagsGrid') as GridContainer
onready var delete_button = get_node('VBox/DeleteButton') as Button
onready var flag_selector = preload('res://addons/todo-cards/scenes/flag-selector.tscn') as PackedScene
onready var todo_cards = get_parent()

func _ready() -> void:
	yield(get_tree(), 'idle_frame')
	for c in get_parent().flag_colors:
		add_flag_selector(c)
	delete_button.connect('pressed', self, '_on_delete_flag_pressed')
	connect('about_to_show', self, '_on_about_to_show')
#<END>

func add_flag_selector(_col: Color)-> void:
	var _flag = flag_selector.instance()
	var _style = stylebox.duplicate()
	_style.bg_color = _col
	flags_grid.add_child(_flag)
	_flag.connect('pressed', self, '_on_color_pressed', [_col])
	var _styles := ['normal', 'hover', 'pressed']
	for st in _styles:
		_flag.add_stylebox_override(st, _style)
#<END>

func _on_color_pressed(_col: Color)-> void:
	current_flag.get_stylebox('normal').bg_color = _col
	hide()
#<END>

func _on_delete_flag_pressed()-> void:
	current_flag.get_parent().remove_flag(current_flag)
	current_flag = null
	hide()
#<END>

func _on_about_to_show()-> void:
	flags_grid.get_child(0).call_deferred('grab_focus')
#<END>