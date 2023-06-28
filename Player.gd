extends CharacterBody2D

var speed := 150
var gravity := 980
var fly_speed := 150

var fly_time = 3 # In seconds
var fly_time_max = 3

@onready var jetpack_particle := $GPUParticles2D
@onready var sprite := $Sprite2D
@onready var animation_player := $AnimationPlayer
@onready var audio_stream := $AudioStreamPlayer

@onready var streams_walk := [preload("res://footstep_grass_000.ogg"), preload("res://footstep_grass_001.ogg"), preload("res://footstep_grass_002.ogg"), preload("res://footstep_grass_003.ogg"), preload("res://footstep_grass_004.ogg")]
@onready var streams_fly := [preload("res://footstep_snow_000.ogg"), preload("res://footstep_snow_001.ogg"), preload("res://footstep_snow_002.ogg"), preload("res://footstep_snow_003.ogg"), preload("res://footstep_snow_004.ogg")]

@onready var progress_bar = $ProgressBar


func _physics_process(delta):
	#Left-right movement
	velocity.x = Input.get_axis("left", "right")
	velocity.x *= speed
	
	#Flying merchanics
	if Input.is_action_pressed("fly") and fly_time >= 0:
		velocity.y = -fly_speed
		jetpack_particle.emitting = true
		fly_time -= delta
	elif not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = clamp(velocity.y, -300, 300)
		jetpack_particle.emitting = false
	
	#Recharge fly time
	if is_on_floor():
		fly_time += delta
		fly_time = clamp(fly_time, 0, fly_time_max)
		
	set_sprite()
	set_animation()
	set_fuel_counter()
		
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
		play_random_sound(streams_walk)
	elif velocity.y < 0:
		play_random_sound(streams_fly)
		animation_player.play("flying")
	else:
		animation_player.play("RESET")


func play_random_sound(streams: Array):
	if audio_stream.playing and audio_stream.stream in streams:
		return
	
	var stream = streams[randi() % streams.size()]
	audio_stream.stream = stream
	audio_stream.play()


func set_fuel_counter():
	var fuel_level_percentage: int = (fly_time * 100) / fly_time_max
	
	if fuel_level_percentage >= 100:
		progress_bar.hide()
	else:
		progress_bar.show()
	progress_bar.value = fuel_level_percentage
