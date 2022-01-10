tool
extends PanelContainer

enum {
	ADD_FLAG,
	IMPORT_CARD,
	EXPORT_CARD,
	DELETE_CARD,
}

var data := {}

onready var line_edit = get_node('VBox/Label/LineEdit') as LineEdit
onready var menu_button = get_node('VBox/Label/MenuButton') as MenuButton
onready var flags_grid = get_node('VBox/FlagsGrid') as GridContainer
onready var add_task_button = get_node('VBox/TasksContainer/AddButton') as Button
onready var tasks_container = get_node('VBox/TasksContainer') as VBoxContainer
onready var text_edit = get_node('VBox/Comment/Panel/TextEdit') as TextEdit
onready var todo_cards = get_node('../../../../../') as PanelContainer

func _ready() -> void:
	menu_button.get_popup().connect('id_pressed', self, '_on_menu_popup_id_pressed')
	add_task_button.connect('pressed', self, '_on_add_task_button_pressed')
	line_edit.connect('text_entered', self, '_on_line_edit_text_entered')
	line_edit.connect('focus_exited', self, '_on_line_edit_text_entered', [line_edit.text])
	menu_button.icon = todo_cards.menu_icon
	menu_button.get_stylebox('focus').border_color = todo_cards.accent_color
	if data:
		load_data()
	else:
		line_edit.text = 'New Card'
		flags_grid.add_flag(todo_cards.random_color())
	var _color = Color.white if todo_cards.base_color.v < 0.5 else Color.black
	get_stylebox('panel').set_deferred('border_color', _color)
#<END>

func load_data() -> void:
	for _flag in flags_grid.get_children():
		flags_grid.remove_child(_flag)
		_flag.queue_free()
	tasks_container.free_tasks()
	if data.has('flags'):
			for _col in data['flags']:
				flags_grid.call_deferred('add_flag', Color(_col))
	if data.has('label'):
		line_edit.text = data['label']
	if data.has('comment'):
		text_edit.text = data['comment']
	if data.has('tasks'):
		for _task in data['tasks']:
			tasks_container.call_deferred('add_task' , _task[0], _task[1])
#<END>

func _on_line_edit_text_entered(_text: String):
	line_edit.select(0, 0)
	line_edit.release_focus()
#<END>

func get_card_data()-> Dictionary:
	var _data := {}
	_data['flags'] = []
	if flags_grid.get_child_count() > 0:
		for _flag in flags_grid.get_children():
			_data['flags'].append(_flag.get_stylebox('normal').bg_color.to_html(false))
	_data['label'] = line_edit.text
	_data['comment'] = text_edit.text
	var _tasks = tasks_container.get_node('Tasks') as VBoxContainer
	_data['tasks'] = []
	if _tasks.get_child_count() > 0:
		for _task in _tasks.get_children():
			#? [Task name, Checked]
			var _check_box = _task.get_node('CheckBox')
			var _line_edit = _task.get_node('LineEdit')
			_data['tasks'].append([_line_edit.text, _check_box.pressed])
	return _data
#<END>

func export_card(_data : Dictionary)-> void:
	var _file_path = 'res://addons/todo-cards/exported-cards/'
	var _file = File.new() as File
	var _file_name = _data['label']
	_file.open('%s%s.tdc' % [_file_path, _file_name], File.WRITE)
	_file.store_line(to_json(_data))
	_file.close()
#<END>

func _on_add_task_button_pressed() -> void:
	tasks_container.add_task()
#<END>

func _on_menu_popup_id_pressed(_id: int)-> void:
	match _id:
		ADD_FLAG:
			flags_grid.add_flag(todo_cards.random_color())
		IMPORT_CARD:
			todo_cards.import_popup.cur_card = self
			todo_cards.import_popup.popup_centered()
		EXPORT_CARD:
			export_card(get_card_data())
		DELETE_CARD:
			var _popup = todo_cards.delete_popup
			_popup.card_to_delete = self
			_popup.card_name = line_edit.text
			var _mpos : Vector2 = get_viewport().get_mouse_position()
			_mpos -= _popup.rect_size / 2.0
			var _rect := Rect2(_mpos, _popup.rect_size)
			_popup.popup(_rect)
#<END>
