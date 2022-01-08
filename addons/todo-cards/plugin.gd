tool
extends EditorPlugin

var todo_scene = preload('res://addons/todo-cards/scenes/todo-cards.tscn') as PackedScene
var icon = preload('res://addons/todo-cards/assets/TDC.svg') as Texture
var todo_instance : Control

func _enter_tree()-> void:
  todo_instance = todo_scene.instance()
  get_editor_interface().get_editor_viewport().add_child(todo_instance, true)
  make_visible(false)
  get_editor_interface().set_main_screen_editor('TDC')
#<END>

func _exit_tree()-> void:
  if todo_instance:
    todo_instance.queue_free()
#<END>

func has_main_screen()-> bool:
    return true
#<END>

func make_visible(visible)-> void:
    if todo_instance:
      todo_instance.visible = visible
#<END>

func get_plugin_name()-> String:
  return "TDC"
#<END>

func get_plugin_icon():
  return icon
#<END>