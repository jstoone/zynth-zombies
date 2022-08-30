class_name WorldMap
extends TileMap

@export var pad_count : int = 16
@export var pad_resource: Resource = preload("res://objects/pad.tscn")

var _rng := RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
    spawn_zynth_pads();
    
func spawn_zynth_pads() -> void:
    var cells: Array[Vector2i] = get_used_cells(0)
    for pad in range(0, pad_count):
        for pad_color in Globals.COLORS.values():
            var random_cell_index = _rng.randi_range(0, cells.size() - 1)
            var cell_position = cells[random_cell_index]
            var new_pad:ZynthPad = pad_resource.instantiate()
            new_pad.position = map_to_world(cell_position)
            new_pad.set_color(pad_color)
            self.add_child(new_pad);
