extends Node2D


var current_angle = 0
var rotation_speed = 2

func _ready() -> void:
    print(get_viewport_rect().size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    var direction = Vector2.UP * 100
    var angle = randf_range(0, TAU);
    
    var new_position = direction.rotated(angle)
    
    # x = centerX + (semi-major * sin T)
    # y = centerY + (semi-minor * cos T)
    var center = Vector2(0, 0)
    var max_width = 350;
    var max_height = max_width/1.8;
    
    
    position = Vector2(
        center.x + (max_width * sin(deg2rad(current_angle))),
        center.y + (max_height * cos(deg2rad(current_angle)))
    )
    
    current_angle += rotation_speed
    
