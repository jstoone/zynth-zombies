extends Node2D

signal spawned_zombie(zombie: Zombie)

@export var wave_label: Label = null;
@export var spawn_margin: Vector2 = Vector2(100, 150)

const Zombie := preload("res://enemies/zombie.tscn")

# Will be set by wave manager
var wave := 0;

# Called when the node enters the scene tree for the first time.
func _ready():
    spawn_enemy()
    
func _process(_delta: float) -> void:
    wave_label.text = 'wave: %s' %wave
 
func spawn_enemy() -> Zombie:

    var viewport: Rect2 = get_viewport_rect()
    var current_position: Vector2 = get_viewport().get_camera_2d().position
    var current_zombie: Zombie = Zombie.instantiate()
    
    # Generate new position outside of the viewport,
    #   but within the margin offset.
    # There is a 50/50 chance that the coordinate will negate
    #   this is so that the enemy can be left, right, up and down.
    current_zombie.position = current_position + Vector2(
        (1 if randi_range(0, 1) else -1) * randf_range(viewport.size.x/2, (viewport.size.x / 2) + spawn_margin.x),
        (1 if randi_range(0, 1) else -1) * randf_range(viewport.size.y/2, (viewport.size.y / 2) + spawn_margin.y),
    )
    
    var max_color_index = wave / 2
    current_zombie.set_color(Globals.get_random_color(max_color_index))
    
    add_child(current_zombie)
    emit_signal("spawned_zombie", current_zombie)
    
    return current_zombie;

func _on_timer_timeout():
    spawn_enemy()


func _on_wave_manager_goal_reached(wave_goal) -> void:
    wave += 1
    
    print(wave)
