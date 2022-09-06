extends GPUParticles2D

@export var death_impulse := 500
@onready var player := $"../../player" as Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var knockback := player.position.direction_to(position) * death_impulse
    var knockback3D := Vector3(knockback.x, knockback.y, 0);
    
    process_material.set('direction', knockback3D)
    
    emitting = true
    
