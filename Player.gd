extends CharacterBody2D

var speed = 150
var gravity = 980
var fly_speed = 150

@onready var jetpack_particle := $GPUParticles2D
@onready var sprite := $Sprite2D
@onready var animation_player := $AnimationPlayer

func _physics_process(delta):
	velocity.x = Input.get_axis("left", "right")
	velocity.x *= speed
	
	if Input.is_action_pressed("fly"):
		velocity.y = -fly_speed
		jetpack_particle.emitting = true
	elif not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = clamp(velocity.y, -300, 300)
		jetpack_particle.emitting = false
	
	set_sprite()
	set_animation()
	
	move_and_slide()


func set_sprite():
	# Makes sure the sprite won't prefer a direction the velocity is 0
	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false
		
	if velocity.y != 0:
		sprite.animation = "jump"
	else:
		sprite.animation = "move"


func set_animation():
	if velocity.x != 0 and velocity.y == 0:
		animation_player.play("moving")
	elif velocity.y < 0:
		animation_player.play("flying")
	else:
		animation_player.play("RESET")
