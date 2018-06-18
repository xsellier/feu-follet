extends KinematicBody2D

enum FEUFOLLET_STATES {
  READY,
  NOT_READY
}

const NORMAL_COLOR = Color('#dbaf6c')
const HOT_COLOR = Color('#ed4c30')

const DELTA_THRESHOLD = 0.5
const MAXIMUM_DISTANCE = 1920

const GRAVITY_VEC = Vector2(0,980)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 50
const MIN_ONAIR_TIME = 0.01
const RUN_SPEED = 600 # pixels/sec
const WALK_SPEED = 250 # pixels/sec
const JUMP_SPEED = 750
const SIDING_CHANGE_SPEED = 10

# Feufollet controls
var current_loading_status = 100
var feufollet_state = FEUFOLLET_STATES.READY
var current_delta = 0.0

var linear_vel = Vector2()
var onair_time = 0 # 
var on_floor = false
var anim = ""
var won = false

onready var fire_animation_node = get_node('fire/animation')
onready var explode_particle_node = get_node('explode')
onready var fire_particle_node = get_node('fire')
onready var viewport_node = get_viewport()

signal burn

func _fixed_process(delta):
  if won:
    return

  current_delta += delta

  # Action boom
  if Input.is_action_pressed("explode") and current_loading_status >= 100:
    current_loading_status = 0

    feufollet_state = FEUFOLLET_STATES.NOT_READY
    explode_particle_node.set_emitting(true)
    fire_animation_node.play('not-ready')

    emit_signal('burn')

  if current_delta > DELTA_THRESHOLD:
    current_delta -= DELTA_THRESHOLD
    current_loading_status = clamp(current_loading_status + 5, 0, 101)

    if current_loading_status >= 100 and feufollet_state == FEUFOLLET_STATES.NOT_READY:
      feufollet_state = FEUFOLLET_STATES.READY
      fire_animation_node.play_backwards('not-ready')

    if feufollet_state == FEUFOLLET_STATES.READY:
      var distance = viewport_node.get_distance()
      var color_factor = 1.0 - clamp(distance / MAXIMUM_DISTANCE, 0.0, 0.99)
      var next_color = NORMAL_COLOR.linear_interpolate(HOT_COLOR, color_factor)
      print(distance)
      fire_particle_node.set_color(next_color)
  
  #increment counters
  onair_time += delta

  ### MOVEMENT ###
  
  # Apply Gravity
  linear_vel += delta * GRAVITY_VEC
  # Move and Slide
  linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
  # Detect Floor
  if is_move_and_slide_on_floor():
    onair_time = 0    
    
  on_floor = onair_time < MIN_ONAIR_TIME
  
  ### CONTROL ###
  
  # Horizontal Movement
  var target_speed = 0
  if Input.is_action_pressed("move_left"):
    target_speed += -1
  if Input.is_action_pressed("move_right"):
    target_speed +=  1
  
  if Input.is_action_pressed("walk"):
    target_speed *= WALK_SPEED
  else:
    target_speed *= RUN_SPEED
  linear_vel.x = lerp( linear_vel.x, target_speed, 0.1 )
  
  # Jumping
  if on_floor and Input.is_action_pressed("jump"):
    linear_vel.y=-JUMP_SPEED
 
  ### ANIMATION ###
  
  var new_anim="idle"
  
  if on_floor:
    if linear_vel.x < -SIDING_CHANGE_SPEED:
      new_anim="run"
      
    if linear_vel.x > SIDING_CHANGE_SPEED:
      new_anim="run"
      
  else:
    if linear_vel.y < 0:
      new_anim="jumping"
    else:
      new_anim="falling"

  if new_anim != anim:
    anim = new_anim
    # get_node("anim").play(anim)

func _ready():
  set_fixed_process(true)

