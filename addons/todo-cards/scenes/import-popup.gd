tool
extends WindowDialog

var cur_card = null

onready var buttons_container = get_node('VBox/Scroll/VBox') as VBoxContainer

func _ready() -> void:
	connect('about_to_show', self, '_on_popup_show')
#<END>

func _on_popup_show() -> void:
	for _child in buttons_container.get_children():
		buttons_container.remove_child(_child)
		_child.queue_free()
	var _dir := Directory.new()
	var _path := 'res://addons/todo-cards/exported-cards/'
	if _dir.open(_path) == OK:
		_dir.list_dir_begin()
		var _file_name : String = _dir.get_next()
		while _file_name != '':
			if _file_name.get_extension() == 'tdc':
				var _button = Button.new()
				_button.text = _file_name.get_basename()
				_button.connect('pressed', self, '_on_button_pressed', [_path + _file_name])
				buttons_container.add_child(_button)
			_file_name = _dir.get_next()
	if buttons_container.get_children():
		buttons_container.get_child(0).call_deferred('grab_focus')
#<END>

func _on_button_pressed(_path: String) -> void:
	var _file = File.new()
	if _file.file_exists(_path):
		_file.open(_path, File.READ)
		if cur_card:
			cur_card.data = parse_json(_file.get_line())
			cur_card.load_data()
		_file.close()
	cur_card = null
	hide()
#<END>
