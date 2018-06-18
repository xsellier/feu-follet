extends Viewport

const BURN_SCENE = preload('res://scenes/burn.scn')

const TILESET_HELPER = preload('res://scripts/utils/tileset.gd')
const number_utils = preload('res://scripts/utils/number.gd')
const DISTANCE = 75

onready var background_node = get_node('background')
onready var furniture_node = get_node('furniture')
onready var objects_node = get_node('objects')
onready var character_node = get_node('character')

var hunted_object = null
var hunted_object_position = Vector2(0.0, 0.0)

func _ready():
  TILESET_HELPER.build_lights(self, background_node)
  TILESET_HELPER.build_lights(self, furniture_node)

  var children_nodes = objects_node.get_children()
  var max_children = children_nodes.size()
  var children_index = number_utils.random(0, max_children)

  hunted_object = children_nodes[children_index]
  hunted_object_position = hunted_object.get_global_pos()

  character_node.connect('burn', self, 'validate_burn')

func validate_burn():
  var distance = get_distance()

  if distance < DISTANCE:
    # Disable the character
    character_node.won = true

    var burn_scene_instance = BURN_SCENE.instance()

    objects_node.add_child(burn_scene_instance)
    burn_scene_instance.get_node('sprite').set_texture(hunted_object.get_node('sprite').get_texture())
    burn_scene_instance.set_pos(hunted_object.get_pos())
    hunted_object.queue_free()

func get_distance():
  var character_pos = character_node.get_global_pos()

  return hunted_object_position.distance_to(character_pos)