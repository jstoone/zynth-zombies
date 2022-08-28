class_name ZynthPad
extends Sprite2D

var reactive_after: float = 1.5
var current_color: int = Globals.COLORS.RED
var is_active: bool = true

func set_color(color_index: int):
    current_color = color_index
    
func _process(_delta):
    frame_coords = Vector2(
        current_color,
        0 if is_active else 1
    )

func _on_body_entered(_body: CharacterBody2D):
    if not is_active:
        return

    is_active = false
    Globals.spawn_zynth(global_position).set_color(current_color)
    get_tree().create_timer(reactive_after, false).connect("timeout", _reactivate)
    
func _reactivate():
    is_active = true;
