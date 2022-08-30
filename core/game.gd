extends Node2D

@onready var fps_label: Label = $ui_overlay/fps_label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    fps_label.text = "%s" %Engine.get_frames_per_second()
