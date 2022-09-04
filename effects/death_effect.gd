extends CharacterBody2D

const FRICTION := 500

@onready var player := $"../../player"
var knockback := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $particles.emitting = true;
    
    knockback = player.position.direction_to(position) * 200
    $particles.process_material.set('direction', knockback)
    $particles.process_material.set('turbulence_noise_speed', knockback.normalized())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
    knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
    velocity = knockback
    
    move_and_slide()
