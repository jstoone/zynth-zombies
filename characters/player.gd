extends CharacterBody2D

const FRICTION := 500

@export var move_speed : float = 5000;
@export var starting_direction : Vector2 = Vector2(0, 1)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var Hitbox := $Hurtbox

var knockback := Vector2.ZERO


## TODO
# - Utilize acceleration and friction -> https://www.youtube.com/watch?v=EQA9MJ5_TxU&list=PL9FzW-m48fn2SlrW0KoLT4n5egNdX-W9a&index=2

func _ready():
    update_animation_parameters(starting_direction)

func _physics_process(delta) -> void:
    # get input direction
    var input_direction : Vector2 = Input.get_vector("left", "right", "up", "down") * move_speed
    
       
    if knockback != Vector2.ZERO:
        knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
        velocity = knockback
    else:
        velocity = input_direction * delta
    
    update_animation_parameters(velocity)
    
    move_and_slide()
    
    pick_new_state()

func update_animation_parameters(move_input : Vector2):
    if (move_input == Vector2.ZERO):
        return
    
    animation_tree.set("parameters/Idle/blend_position", move_input)
    animation_tree.set("parameters/Walk/blend_position", move_input)

func pick_new_state():
    if (velocity == Vector2.ZERO):
        state_machine.travel("Walk")
    else:
        state_machine.travel("Idle")


func _on_hurtbox_body_entered(body: Node2D) -> void:
    knockback = body.position.direction_to(position) * 200
    if body is Zombie:
        body.kill()
