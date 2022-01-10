tool
extends VBoxContainer

var task_scene = preload('res://addons/todo-cards/scenes/task.tscn') as PackedScene

onready var progress_bar : ProgressBar = get_node('ProgressBar') as ProgressBar
onready var tasks_container = get_node('Tasks') as VBoxContainer
onready var cards_container = get_node('../../../../') as ScrollContainer

func add_task(_text:= 'New Task', _pressed := false)-> void:
	var _task = task_scene.instance() as HBoxContainer
	var _check_box = _task.get_node('CheckBox') as CheckBox
	var _xbutton = _task.get_node('XButton') as Button
	var _line_edit = _task.get_node('LineEdit') as LineEdit
	_check_box.connect('toggled', self, '_on_checkbox_toggled', [_task])
	_xbutton.connect('pressed', self, '_on_xbutton_pressed', [_task])
	_line_edit.connect('text_entered', self, '_on_line_edit_text_entered', [_line_edit])
	_line_edit.connect('focus_exited', self, '_on_line_edit_text_entered', [_line_edit.text, _line_edit])
	_line_edit.text = _text
	_check_box.pressed = _pressed
	_xbutton.icon = get_parent().get_parent().todo_cards.close_icon
	tasks_container.add_child(_task)
	_line_edit.call_deferred('grab_focus')
	_line_edit.select_all()
	_check_box.emit_signal('pressed')
	set_progress()
#<END>

func set_progress()-> void:
	var _tasks_count : int = tasks_container.get_child_count()
	if _tasks_count == 0:
		progress_bar.value = 0
		return
	var _completed_tasks := 0
	for _task in tasks_container.get_children():
		_completed_tasks += int(_task.get_node('CheckBox').pressed)
	progress_bar.value = (_completed_tasks/float(_tasks_count)) * 100
#<END>

func free_tasks()-> void:
	for _task in tasks_container.get_children():
		tasks_container.remove_child(_task)
		_task.queue_free()
#<END>

func _on_checkbox_toggled(_pressed: bool, _task: HBoxContainer)-> void:
	var _col = cards_container.todo_cards.accent_color
	var _line_edit = _task.get_node('LineEdit') as LineEdit
	_line_edit.set('custom_colors/font_color', _col if _pressed else null)
	set_progress()
#<END>

func _on_xbutton_pressed(_task: HBoxContainer)-> void:
	tasks_container.remove_child(_task)
	_task.queue_free()
	set_progress()
#<END>

func _on_line_edit_text_entered(_text: String, _line_edit: LineEdit)-> void:
	_line_edit.select(0, 0)
	_line_edit.release_focus()
#<END>