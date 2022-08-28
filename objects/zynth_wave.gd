extends Sprite2D
class_name ZynthWave

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_area: Area2D = $Area2D

var current_color: int = Globals.COLORS.RED

func _ready():
    animation_player.play('wave_red');
    
func _process(delta):
    var colorLayerValue: int = Globals.color_to_layer_value(current_color)
    collision_area.set_collision_mask_value(colorLayerValue, true)
    
    modulate = Globals.get_color_hex(current_color)

func set_color(color_index: int):
    current_color = color_index

func _on_wave_animation_finished(_anim_name):
    queue_free()

func _on_body_entered(body: Zombie):
    body.kill();
    
