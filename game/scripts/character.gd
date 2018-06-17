
extends KinematicBody2D

const GRAVITY_VEC = Vector2(0,980)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25 
const MIN_ONAIR_TIME = 0.01
const RUN_SPEED = 600 # pixels/sec
const WALK_SPEED = 250 # pixels/sec
const JUMP_SPEED = 750
const SIDING_CHANGE_SPEED = 10

var linear_vel = Vector2()
var onair_time = 0 # 
var on_floor = false
var anim=""

func _fixed_process(delta):
  
  #increment counters
  
  onair_time+=delta
 
  
  ### MOVEMENT ###
  
  # Apply Gravity
  linear_vel += delta * GRAVITY_VEC
  # Move and Slide
  linear_vel = move_and_slide( linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP )
  # Detect Floor
  if (is_move_and_slide_on_floor()):
    onair_time = 0    
    
  on_floor = onair_time < MIN_ONAIR_TIME
  
  ### CONTROL ###
  
  # Horizontal Movement
  var target_speed = 0
  if (Input.is_action_pressed("move_left")):
    target_speed += -1
  if (Input.is_action_pressed("move_right")):
    target_speed +=  1
  
  if (Input.is_action_pressed("walk")):
    target_speed *= WALK_SPEED
  else:
    target_speed *= RUN_SPEED
  linear_vel.x = lerp( linear_vel.x, target_speed, 0.1 )
  
  # Jumping
  if (on_floor and Input.is_action_pressed("jump")):
    linear_vel.y=-JUMP_SPEED
 
  ### ANIMATION ###
  
  var new_anim="idle"
  
  if (on_floor):
    if (linear_vel.x < -SIDING_CHANGE_SPEED):
      new_anim="run"
      
    if (linear_vel.x > SIDING_CHANGE_SPEED):
      new_anim="run"
      
  else:
    if (linear_vel.y < 0 ):
      new_anim="jumping"
    else:
      new_anim="falling"

  if (new_anim!=anim):
    anim=new_anim
    # get_node("anim").play(anim)

func _ready():
  set_fixed_process(true)

