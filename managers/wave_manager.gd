class_name WaveManager
extends Node2D

signal wave_started(wave: int)

@onready var wave_label := $'../CanvasLayer/WaveLabel'

var wave = 0
var wave_goal := 50
var wave_progress := 0

func _process(_delta: float) -> void:
    wave_label.text = 'wave: %s' %wave

func _on_spawn_manager_spawned_zombie(zombie: Zombie) -> void:
    zombie.killed.connect(_register_kill)
    
func _register_kill(zombie) -> void:
    wave_progress += 1
    
    if wave_progress >= wave_goal:
        _complete_wave() 

func _complete_wave():
    wave += 1
    wave_progress = 0
    emit_signal("wave_started", wave)    
