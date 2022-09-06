extends GPUParticles2D

@export var death_impulse := 100
var knockback := Vector2.ZERO

@onready var player := $"../../player" as Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    emitting = true
    
    knockback = player.position.direction_to(position) * death_impulse
    var knockback3D := Vector3(knockback.x, knockback.y, 0);
    
    process_material.set('direction', knockback3D)
    
