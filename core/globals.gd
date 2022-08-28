extends Node

var Zynth: PackedScene = null

const COLOR_LAYER_OFFSET = 5

enum COLORS {
    RED,
    BLUE,
    GREEN,
    YELLOW,
}

const COLORS_IN_HEX: Dictionary = {
    COLORS.RED: Color('#ff3731'),
    COLORS.BLUE: Color('#6882f6'),
    COLORS.GREEN: Color('#58cd30'),
    COLORS.YELLOW: Color('#ffee00'),
}

func _ready():
    Zynth = load("res://objects/zynth_wave.tscn")
    
func get_random_color() -> int:
    return randi_range(0, COLORS.size() - 1)

func get_color_hex(color_index: int):
    return COLORS_IN_HEX[color_index]

func color_to_layer_value(color_index: int):
    return color_index + COLOR_LAYER_OFFSET
    
func spawn_zynth(position: Vector2) -> ZynthWave:
    var current_zynth: ZynthWave = Zynth.instantiate()
    
    current_zynth.global_position = position;
    
    call_deferred("add_child", current_zynth)
    
    return current_zynth
