class_name WaveManager
extends Node2D

signal goal_reached(wave_goal: int)
signal registered_kill(zombie: Zombie)

@export var wave_progress := 0
@export var next_wave_goal := 50

func _on_spawn_manager_spawned_zombie(zombie: Zombie) -> void:
    zombie.killed.connect(_register_kill.bind(zombie))
    
func _register_kill(zombie) -> void:
    emit_signal("registered_kill", zombie)
    wave_progress += 1
    print(wave_progress)
    
    if (wave_progress >= next_wave_goal):
        emit_signal("goal_reached", wave_progress)
        wave_progress = 0;
        next_wave_goal += 25
