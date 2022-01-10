tool
extends GridContainer

var flag_scene = preload('res://addons/todo-cards/scenes/flag.tscn') as PackedScene

onready var todo_cards = get_node('../../../../../../../') as PanelContainer

func add_flag(_color: Color)-> void:
	if get_child_count() >= 12:
		return
	var _flag = flag_scene.instance()
	_flag.color = _color
	add_child(_flag)
	_flag.call_deferred('set_styles')
	columns = get_columns_value()
#<END>

func remove_flag(_flag: Button)-> void:
	remove_child(_flag)
	_flag.queue_free()
	columns = get_columns_value()
#<END>

func get_columns_value()-> int:
	return int(min(get_child_count(), 4))
#<END>