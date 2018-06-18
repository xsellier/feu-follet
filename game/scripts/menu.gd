extends Control

const GAME_SCENE = preload('res://scenes/world.scn')

onready var start_node = get_node('container/start')
onready var quit_node = get_node('container/quit')

func _ready():
  quit_node.connect('pressed', get_tree(), 'quit')
  start_node.connect('pressed', get_tree(), 'change_scene_to', [GAME_SCENE])
