#class_name Personaje
#extends CharacterBody2D
#
#@export var speed = 300
#@export var jump_speed = 300
#@export var max_jump_speed = 600      
#@export var gravity = 600
#@export var max_charge_time = 1.0 # Tiempo máximo de carga en segundos
#@onready var sprite_2d = $Sprite2D
#
## Estados para regular animaciones
#var is_jumping = false
#var is_falling = false
#var jump_charge_time = 0.0
#var jump_animation_finished = false
#
#func _physics_process(delta):
#
	## Movimiento horizontal
	#var direction = Input.get_axis("Izquierda", "Derecha")
	#velocity.x = speed * direction
#
	## Carga de salto 
	#if Input.is_action_pressed("Saltar") and is_on_floor():
		#jump_charge_time += delta
		#if jump_charge_time > max_charge_time:
			#jump_charge_time = max_charge_time
		#
		#$AnimationPlayer.play("saltar")  # Salto durante carga
		#is_jumping = true
		#is_falling = false
		#jump_animation_finished = false
#
	## Salto
	#if Input.is_action_just_released("Saltar") and is_on_floor():
		#var charge_factor = jump_charge_time / max_charge_time
		#var actual_jump_speed = lerp(jump_speed, max_jump_speed, charge_factor)
		#velocity.y -= actual_jump_speed
		#
		#is_jumping = true
		#is_falling = false
		#jump_charge_time = 0.0
		#jump_animation_finished = false
#
	#if direction != 0:
		#sprite_2d.scale.x = direction
#
		#if is_on_floor() and not is_jumping and not is_falling:
			#$AnimationPlayer.play("caminar")
#
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
		#if not is_jumping and not is_falling:
			#if not jump_animation_finished:
				#$AnimationPlayer.play("soltar")
				#jump_animation_finished = true
			#is_falling = true
	#else:
		#is_jumping = false
		#is_falling = false
	#
	#
	#move_and_slide()





# --------- AÚN SE MUEVE EN EL AIRE --------------

#extends CharacterBody2D
#
## Constantes
#const GRAVITY = 600
#const JUMP_FORCE = 550
#const MOVE_SPEED = 200
#const MAX_JUMP_CHARGE = 1.5  # tiempo máximo de carga en segundos
#
## Variables
#var jump_charge_time = 0.0
#var is_charging_jump = false
#var on_ground = false
#
#func _ready():
	#pass
#
#func _physics_process(delta):
	#on_ground = is_on_floor()
#
	#if on_ground:
		#if Input.is_action_just_pressed("Saltar"):
			#is_charging_jump = true
			#jump_charge_time = 0.0
		#elif Input.is_action_just_released("Saltar"):
			#if is_charging_jump:
				#jump()
				#is_charging_jump = false
		#else:
			#if is_charging_jump:
				#jump_charge_time += delta
				#if jump_charge_time > MAX_JUMP_CHARGE:
					#jump_charge_time = MAX_JUMP_CHARGE
#
	#if not on_ground:
		#apply_gravity(delta)
		#
	#handle_movement(delta)
#
#func apply_gravity(delta):
	#velocity.y += GRAVITY * delta
	#move_and_slide()
#
#func handle_movement(delta):
	#var direction = 0
	#if Input.is_action_pressed("Derecha"):
		#direction += 1
	#if Input.is_action_pressed("Izquierda"):
		#direction -= 1
	#
	#if direction != 0:
		#velocity.x = direction * MOVE_SPEED
	#else:
		#velocity.x = 0
#
	#move_and_slide()
#
#func jump():
	#var jump_strength = JUMP_FORCE * min(jump_charge_time / MAX_JUMP_CHARGE, 1.0)
	#velocity.y = -jump_strength
	#
	
	
	


# ---------------------- Animaciones y Ruta parabólica -------------------------------------


extends CharacterBody2D

# Constantes
const GRAVITY = 600
const JUMP_FORCE = 400
const MOVE_SPEED = 200
const MAX_JUMP_CHARGE = 1.5  # tiempo máximo de carga en segundos

# Variables
var jump_charge_time = 0.0
var is_charging_jump = false
var on_ground = false

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer

# Estados para regular animaciones
var is_jumping = false
var is_falling = false
var jump_animation_finished = false
var last_direction = 1  # 1 para derecha, -1 para izquierda

func _physics_process(delta):
	on_ground = is_on_floor()

	if on_ground:
		if Input.is_action_just_pressed("Saltar"):
			is_charging_jump = true
			jump_charge_time = 0.0
			animation_player.play("saltar")
			is_jumping = true
			is_falling = false
			jump_animation_finished = false
		elif Input.is_action_just_released("Saltar"):
			if is_charging_jump:
				jump()
				is_charging_jump = false
				is_jumping = true
				is_falling = false
				jump_animation_finished = false
		elif is_charging_jump:
			jump_charge_time += delta
			if jump_charge_time > MAX_JUMP_CHARGE:
				jump_charge_time = MAX_JUMP_CHARGE

	handle_movement(delta)
	
	if not on_ground:
		apply_gravity(delta)

	# Control de animaciones cuando no está en el suelo
	if not is_on_floor():
		if not is_jumping and not is_falling:
			if not jump_animation_finished:
				animation_player.play("soltar")
				jump_animation_finished = true
			is_falling = true
	else:
		is_jumping = false
		is_falling = false
	
	# Control de animaciones de caminar y reposo
	if on_ground and not is_jumping and not is_falling:
		if velocity.x != 0:
			animation_player.play("caminar")
			sprite_2d.scale.x = sign(velocity.x)
			last_direction = sign(velocity.x)  # Actualizar la dirección
		elif not is_charging_jump:
			animation_player.play("reposo")

	# Mantener la dirección durante las animaciones en el aire
	if is_jumping or is_falling or is_charging_jump:
		sprite_2d.scale.x = last_direction

	move_and_slide()

func apply_gravity(delta):
	velocity.y += GRAVITY * delta

func handle_movement(delta):
	if on_ground:
		if is_charging_jump:
			# Mantén al personaje fijo mientras se carga el salto
			velocity.x = 0
			velocity.y = 0
		else:
			var direction = 0
			if Input.is_action_pressed("Derecha"):
				direction += 1
			if Input.is_action_pressed("Izquierda"):
				direction -= 1

			if direction != 0:
				velocity.x = direction * MOVE_SPEED
			else:
				velocity.x = 0

func jump():
	var jump_strength = JUMP_FORCE * min(jump_charge_time / MAX_JUMP_CHARGE, 1.0)
	velocity.y = -jump_strength









# ------------------ Correción de animaciones --------------------


#extends CharacterBody2D
#
## Constantes
#const GRAVITY = 600
#const JUMP_FORCE = 400
#const MOVE_SPEED = 200
#const MAX_JUMP_CHARGE = 1.5  # tiempo máximo de carga en segundos
#
## Variables
#var jump_charge_time = 0.0
#var is_charging_jump = false
#var on_ground = false
#
#@onready var sprite_2d = $Sprite2D
#@onready var animation_player = $AnimationPlayer
#
## Estados para regular animaciones
#var is_jumping = false
#var is_falling = false
#var jump_animation_finished = false
#var last_direction = 1  # 1 para derecha, -1 para izquierda
#
#func _physics_process(delta):
	#on_ground = is_on_floor()
#
	#if on_ground:
		#if Input.is_action_just_pressed("Saltar"):
			#is_charging_jump = true
			#jump_charge_time = 0.0
			#animation_player.play("saltar")
			#is_jumping = true
			#is_falling = false
			#jump_animation_finished = false
		#elif Input.is_action_just_released("Saltar"):
			#if is_charging_jump:
				#jump()
				#is_charging_jump = false
				#is_jumping = true
				#is_falling = false
				#jump_animation_finished = false
		#elif is_charging_jump:
			#jump_charge_time += delta
			#if jump_charge_time > MAX_JUMP_CHARGE:
				#jump_charge_time = MAX_JUMP_CHARGE
#
	#handle_movement(delta)
	#
	#if not on_ground:
		#apply_gravity(delta)
#
	## Control de animaciones cuando no está en el suelo
	#if not is_on_floor():
		#if not is_jumping and not is_falling:
			#if not jump_animation_finished:
				#animation_player.play("soltar")
				#jump_animation_finished = true
			#is_falling = true
	#else:
		#is_jumping = false
		#is_falling = false
	#
	## Control de animaciones de caminar y reposo
	#if on_ground and not is_jumping and not is_falling:
		#if velocity.x != 0:
			#animation_player.play("caminar")
			#sprite_2d.scale.x = sign(velocity.x)
			#last_direction = sign(velocity.x)  # Actualizar la dirección
		#elif not is_charging_jump:
			#animation_player.play("reposo")
#
	## Mantener la dirección durante las animaciones en el aire
	#if is_jumping or is_falling or is_charging_jump:
		#sprite_2d.scale.x = last_direction
#
	#move_and_slide()
#
#func apply_gravity(delta):
	#velocity.y += GRAVITY * delta
#
#func handle_movement(delta):
	#if on_ground:
		#if is_charging_jump:
			## Mantén al personaje fijo mientras se carga el salto
			#velocity.x = 0
			#velocity.y = 0
		#else:
			#var direction = 0
			#if Input.is_action_pressed("Derecha"):
				#direction += 1
			#if Input.is_action_pressed("Izquierda"):
				#direction -= 1
#
			#if direction != 0:
				#velocity.x = direction * MOVE_SPEED
			#else:
				#velocity.x = 0
#
#func jump():
	#var jump_strength = JUMP_FORCE * min(jump_charge_time / MAX_JUMP_CHARGE, 1.0)
	#velocity.y = -jump_strength



