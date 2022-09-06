class_name Zombie
extends CharacterBody2D

signal killed(zombie: Zombie)

var DeathEffect: PackedScene = null;

@export var move_speed: int = 2000
var current_color: int = Globals.COLORS.RED


func set_color(color_index: int):
    current_color = color_index
    
func _ready():
    _setup_color()
    DeathEffect = load("res://effects/death_effect.tscn")
    
func _setup_color():
    var colorLayerValue: int = Globals.get_color_layer(current_color)
    set_collision_layer_value(colorLayerValue, true)
    
    modulate = Globals.get_color_hex(current_color)

func _physics_process(delta):
    var camera_position = get_viewport().get_camera_2d().position;
    var speed = position.direction_to(camera_position)
    
    velocity = speed * move_speed * delta
    
    move_and_slide()
    
func kill():
    var ripple_zynth: ZynthWave = Globals.spawn_zynth(global_position)  
    ripple_zynth.set_color(current_color)
    ripple_zynth.scale *= 0.35
    
    var death_effect = DeathEffect.instantiate()
    death_effect.global_position = global_position
    
    emit_signal("killed", self)
    call_deferred('add_sibling', death_effect)
    
    queue_free();
