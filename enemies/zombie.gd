class_name Zombie
extends CharacterBody2D

@export var move_speed: int = 2000

var current_color: int = Globals.COLORS.RED

func set_color(color_index: int):
    current_color = color_index

func kill():
    var ripple_zynth: ZynthWave = Globals.spawn_zynth(global_position)
    ripple_zynth.set_color(current_color)
    ripple_zynth.scale *= 0.35
    
    queue_free();
    
func _ready():
    _setup_color()
    
func _setup_color():
    var colorLayerValue: int = Globals.color_to_layer_value(current_color)
    set_collision_layer_value(colorLayerValue, true)
    
    modulate = Globals.get_color_hex(current_color)

func _physics_process(delta):
    var camera_position = get_viewport().get_camera_2d().position;
    var speed = position.direction_to(camera_position)
    
    velocity = speed * move_speed * delta
    
    move_and_slide()
