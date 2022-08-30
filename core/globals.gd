extends Node

enum COLORS {
    RED,
    BLUE,
    GREEN,
    YELLOW,
}

const COLOR_LAYER_OFFSET = 5
const COLORS_IN_HEX: Dictionary = {
    COLORS.RED: Color('ff3731'),
    COLORS.BLUE: Color('6882f6'),
    COLORS.GREEN: Color('58cd30'),
    COLORS.YELLOW: Color('ffee00'),
}

var Zynth: PackedScene = null

func _ready():
    Zynth = load('res://objects/zynth_wave.tscn')
    
func get_random_color(max_color_index: int = COLORS.size() - 1) -> int:
    return min(randi_range(0, max_color_index), COLORS.size() -1)

func get_color_hex(color_index: int):
    return COLORS_IN_HEX[color_index]

func color_to_layer_value(color_index: int):
    return color_index + COLOR_LAYER_OFFSET
    
func spawn_zynth(position: Vector2) -> ZynthWave:
    var current_zynth: ZynthWave = Zynth.instantiate()
    
    current_zynth.global_position = position;
    
    call_deferred('add_child', current_zynth)
    
    return current_zynth
