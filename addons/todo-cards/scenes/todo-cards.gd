tool
extends PanelContainer

const PROJECT_PATH := 'res://addons/todo-cards/data.tdp'
const flag_colors := [
	Color.lightskyblue, Color.cyan, Color.dodgerblue, Color.crimson,
	Color.violet, Color.deeppink, Color.greenyellow, Color.lightcoral,
	Color.lightsalmon, Color.palegreen, Color.seagreen, Color.slategray,
	Color.snow, Color.teal, Color.sandybrown, Color.palegoldenrod
]

var _ctrl_pressed := false
var project_check : int
var accent_color := Color.white
var base_color := Color.white
var menu_icon : Texture
var close_icon : Texture

var data := [
	{
		'flags': [Color.crimson, Color.snow, Color.crimson],
		'label': 'Hello Card',
		'comment': '* Important\n# comment\n! warning\n$ Question ?\n@ TODO\n\"do\"[u]<want>(more)?\nHope You like it! <3',
		'tasks': [
			['1- finish this plugin', true],
			['2- release the plugin', true],
			['3- get feedback', false]
		]
	}
]

onready var cards_container = get_node('HBox/VBox/CardsContainer') as ScrollContainer
onready var flag_popup = get_node('FlagPopup') as WindowDialog
onready var delete_popup = get_node('DeletePopup') as WindowDialog
onready var import_popup = get_node('ImportPopup') as WindowDialog
onready var rnd = RandomNumberGenerator.new() as RandomNumberGenerator
onready var timer = get_node('Timer') as Timer

func _ready() -> void:
	load_data()
	process_data()
	var _flag_focus_stylebox = preload('res://addons/todo-cards/assets/flag-focus.stylebox') as StyleBoxFlat
	_flag_focus_stylebox.border_color = accent_color
	cards_container.connect('gui_input', self, '_on_gui_input')
	timer.connect('timeout', self, '_on_timer_timeout')
	var _color = Color.white if base_color.v < 0.5 else Color.black
	get_stylebox('panel').border_color = _color
#<END>

func _unhandled_input(event: InputEvent)-> void:
	if !visible:
		return
	if !event is InputEventKey:
		return
	if event.echo:
		return
	var _keys := [KEY_CONTROL, KEY_S, KEY_ESCAPE]
	if !_keys.has(event.scancode):
		return
	if event.pressed:
		if event.scancode == KEY_CONTROL:
			_ctrl_pressed = true
			return
		if event.scancode == KEY_ESCAPE:
			control_unfocus()
			return
		if _ctrl_pressed and event.scancode == KEY_S:
			save_project()
	else:
		if !event.scancode == KEY_CONTROL:
			return
		_ctrl_pressed = false
#<END>

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		if timer.is_stopped():
			timer.start()
#<END>

func random_color()-> Color:
	rnd.randomize()
	var _randi = rnd.randi_range(0, flag_colors.size() - 1)
	return flag_colors[_randi]
#<END>

func load_data()-> void:
	var _file = File.new()
	if _file.file_exists(PROJECT_PATH):
		_file.open(PROJECT_PATH, File.READ)
		data = _file.get_var()
		_file.close()
	else:
		_file.open(PROJECT_PATH, File.WRITE)
		_file.store_var(data)
		_file.close()
		project_check = _file.get_modified_time(PROJECT_PATH)
#<END>

func process_data()-> void:
	for _data in data:
		cards_container.add_card(_data)
#<END>

func control_unfocus()-> void:
	var _focus_owner = get_focus_owner()
	if !_focus_owner:
		return
	if _focus_owner.get_class() == 'LineEdit':
		_focus_owner.select(0, 0)
	_focus_owner.release_focus()
#<END>

func save_project()-> void:
	var _file := File.new()
	_file.open(PROJECT_PATH, File.WRITE)
	_file.store_var(cards_container.get_data())
	_file.close()
	project_check = _file.get_modified_time(PROJECT_PATH)
#<END>

func _on_gui_input(event: InputEvent)-> void:
	if !event is InputEventMouseButton:
		return
	if event.is_pressed():
		control_unfocus()
#<END>

func _on_timer_timeout():
	var _file = File.new()
	if _file.file_exists(PROJECT_PATH):
		if project_check != _file.get_modified_time(PROJECT_PATH):
			project_check = _file.get_modified_time(PROJECT_PATH)
			load_data()
			cards_container.free_cards()
			process_data()
#<END>