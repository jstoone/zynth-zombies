extends Node2D

signal spawned_zombie(zombie: Zombie)

@export var difficulty := 0.0
@export var spawn_offset := Vector2(70, 50)

const Zombie := preload("res://enemies/zombie.tscn")

@onready var WaveManager := $"../wave_manager" as WaveManager
@onready var Player := $"../player" as Player
@onready var spawn_peak := Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
 
func spawn_enemy() -> Zombie:
    var current_zombie: Zombie = Zombie.instantiate()
    
    current_zombie.set_color(Globals.get_random_color(difficulty))
    current_zombie.position = _get_spawn_position()
    
    add_child(current_zombie)
    emit_signal("spawned_zombie", current_zombie)
    
    return current_zombie;
    
func _get_spawn_position() -> Vector2:
    var center = Player.position
    var angle = randf_range(0, TAU)

    return Vector2(
        center.x + ((spawn_peak.x+spawn_offset.x) * sin(angle)),
        center.y + ((spawn_peak.y+spawn_offset.y) * cos(angle))
    )

func _on_timer_timeout():
    spawn_enemy()

func _on_wave_manager_wave_started(wave) -> void:
    difficulty = wave / 2
