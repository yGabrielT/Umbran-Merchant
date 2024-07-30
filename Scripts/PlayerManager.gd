extends CharacterBody3D


@export var SPEED = 5.0

@export var SENSITIVITY = 0.01

#bob variables
@export var BOB_FREQ = 2.4
@export var BOB_AMP = 0.05
var t_bob = 0.0 
var idle_bob = 0.0
var cos_value = 2.0
var velocity_valuer = 0.0
var isMouseCaptured = false
var mouse1 = false
var mouse2 = false
#Raycast
var raycastObj : Node3D = null
var isLookingToItem = false
var isLeftHandOccupied = false
var isRightHandOccupied = false
var canInterpolate = false
var t =0.0
var leftHandObj : Node3D
var rightHandObj : Node3D

var lastraycastobj : Node3D
var lookedOff = true
var gotFirstLastRay = false

#RaycastPlace
var raycastPlaceGlobalPoint : Vector3
var raycastPlaceNormal : Vector3
var canPlace = false
var hand1cooldown = false
var hand2cooldown = false

#raycast
@onready var RaycastPotion : RayCast3D = $Head/Camera3D/RaycastPotion
@onready var RaycastPlaceToPut : RayCast3D = $Head/Camera3D/RaycastPlaceToPut
@onready var RaycastGetBook: RayCast3D = $Head/Camera3D/RaycastBook

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var head = $Head
@onready var camera = $Head/Camera3D

#BodyEntered in Area
var arrayOfBodies = []

#Color
var colorOfTarget
var leftHandObjLiquidColor
var rightHandObjLiquidColor
var newColor

#BookPage
@export var BookUI : Control
var isBookOpen = false

#Audios
@export var PickPotOnTableSFX : AudioStream
@export var PutPotOnTableSFX : AudioStream
var canStep = true
@export var StepSFX : AudioStream
@export var liquidPourInSFX : AudioStream



func _unhandled_input(event):
	if event is InputEventMouseMotion and not isBookOpen:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		

func _input(event):
	if not isBookOpen and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseButton:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			

func _physics_process(delta):
#region Player Movement

	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if(not isBookOpen):
		var input_dir = Input.get_vector("left", "right", "up", "down")
		var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = 0.0
			velocity.z = 0.0
	else:
		velocity = Vector3.ZERO
#endregion
	
#region HeadBob
	# Head bob
	
	
	if velocity.length() == 0.0:
		cos_value = lerp(cos_value, 0.0, delta * 10)
		velocity_valuer = .5
	else:
		cos_value = lerp(cos_value, .5, delta * 10)
		velocity_valuer = velocity.length()
		
	t_bob += delta * velocity_valuer * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	var ypos = _headbob(t_bob).y
	ypos = snapped(ypos,0.001)
	
	if ypos == (BOB_AMP) and velocity.length() != 0.0 and not canStep:
		canStep = true
		
	
	if ypos == (-BOB_AMP) and velocity.length() != 0.0 and canStep:
		canStep = false
		SoundManager.play_sound_with_pitch(StepSFX,randf_range(.5,.8))
	

	move_and_slide()
#endregion
	
#region Raycast

	if RaycastPotion.is_colliding() and RaycastPotion.get_collider() != null:
		
		raycastObj = RaycastPotion.get_collider().get_node("Outliner")
		raycastObj.visible = true
		isLookingToItem = true
		if lastraycastobj == null:
			gotFirstLastRay = true
			lastraycastobj = raycastObj
		
		if lastraycastobj != raycastObj:
			lastraycastobj.visible = false
			lastraycastobj = raycastObj
	else:
		if lastraycastobj != null:
			lastraycastobj.visible = false
		if raycastObj != null:
			raycastObj.visible = false
		isLookingToItem = false
#endregion
	

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * (BOB_AMP * cos_value)
	
	return pos

func _process(delta):
	
	
	if not hand1cooldown:
		mouse1 = Input.is_action_pressed("mouse1")
	if not hand2cooldown:
		mouse2 = Input.is_action_pressed("mouse2")
	GrabPotion()
	mixPotion()
	RaycastAPlaceToPut()
	PutDownPotion()
	RaycastBook()
	ManageBook()

func GrabPotion():
	if mouse1 == true and isLookingToItem == true and isLeftHandOccupied == false and not mouse2 and not hand1cooldown:
		raycastObj.get_parent().get_node("CollisionShape3D").disabled = true
		hand1cooldown = true
		isLeftHandOccupied = true
		mouse1 = false
		raycastObj.get_parent().reparent($Head/Camera3D/LeftHand)
		leftHandObj = raycastObj.get_parent()
		canInterpolate = true
		SoundManager.play_sound_with_pitch(PickPotOnTableSFX, randf_range(.7,1.3))
		var tween = get_tree().create_tween()
		tween.tween_property(raycastObj.get_parent(), "position", $Head/Camera3D/LeftHand.position, .07).set_ease(Tween.EASE_IN)
		tween.tween_callback( func():
			hand1cooldown = false).set_delay(.5)
		
		
		
	if mouse2 == true and isLookingToItem == true and isRightHandOccupied == false and not mouse1 and not hand2cooldown:
		raycastObj.get_parent().get_node("CollisionShape3D").disabled = true
		hand2cooldown = true
		isRightHandOccupied = true
		mouse2 = false
		raycastObj.get_parent().reparent($Head/Camera3D/RightHand)
		rightHandObj = raycastObj.get_parent()
		canInterpolate = true
		SoundManager.play_sound_with_pitch(PickPotOnTableSFX, randf_range(.7,1.3))
		var tween = get_tree().create_tween()
		tween.tween_property(raycastObj.get_parent(), "position", $Head/Camera3D/RightHand.position, .07).set_ease(Tween.EASE_IN)
		tween.tween_callback( func():
			hand2cooldown = false).set_delay(.5)
func RaycastAPlaceToPut():
	if RaycastPlaceToPut.is_colliding():
		raycastPlaceGlobalPoint = RaycastPlaceToPut.get_collision_point()
		raycastPlaceNormal = RaycastPlaceToPut.get_collision_normal()
		
		if raycastPlaceNormal.y > .8 and raycastPlaceNormal.y < 1.2:
			canPlace = true
		else:
			canPlace = false
	else:
			canPlace = false
func PutDownPotion():
	if isLeftHandOccupied and mouse1 and not isLookingToItem and canPlace and not mouse2 and not hand1cooldown:
		isLeftHandOccupied = false
		hand1cooldown = true
		canPlace = false
		mouse1 = false
		leftHandObj.reparent(RaycastPlaceToPut.get_collider())
		
		var tween = get_tree().create_tween()
		leftHandObj.global_transform = align_with_y(leftHandObj.global_transform, raycastPlaceNormal)
		tween.tween_callback( func():
			hand1cooldown = false)
		tween.tween_property(leftHandObj, "global_position", raycastPlaceGlobalPoint, .07).set_ease(Tween.EASE_IN)
		tween.tween_callback(func():
			leftHandObj.get_node("CollisionShape3D").disabled = false
			SoundManager.play_sound_with_pitch(PutPotOnTableSFX, randf_range(.7,1.3)))
		tween.tween_callback(func():
			
			hand1cooldown = false).set_delay(.5)
		
	if isRightHandOccupied and mouse2 and not isLookingToItem and canPlace and not mouse1 and not hand2cooldown:
		isRightHandOccupied = false
		hand2cooldown = true
		canPlace = false
		mouse2 = false
		
		rightHandObj.reparent(RaycastPlaceToPut.get_collider())
		
		var tween = get_tree().create_tween()
		rightHandObj.global_transform = align_with_y(rightHandObj.global_transform, raycastPlaceNormal)
		tween.tween_property(rightHandObj, "global_position", raycastPlaceGlobalPoint, .07).set_ease(Tween.EASE_IN)
		tween.tween_callback(func():
			rightHandObj.get_node("CollisionShape3D").disabled = false
			SoundManager.play_sound_with_pitch(PutPotOnTableSFX, randf_range(.7,1.3)))
		tween.tween_callback(func():
			
			hand2cooldown = false
			).set_delay(.5)
func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
func mixPotion():
	if mouse1 == true and isLookingToItem == true and isLeftHandOccupied == true and not mouse2 and raycastObj != null:
		if len(raycastObj.get_parent().liquids) == 1 and len(leftHandObj.liquids) == 1:
			print("got it")
			colorOfTarget = Color(
				raycastObj.get_parent().liquids[0].x,
				raycastObj.get_parent().liquids[0].y,
				raycastObj.get_parent().liquids[0].z,
				raycastObj.get_parent().liquids[0].w)
			leftHandObjLiquidColor = Color(
				leftHandObj.liquids[0].x,
				leftHandObj.liquids[0].y,
				leftHandObj.liquids[0].z,
				leftHandObj.liquids[0].w)
			if raycastObj.get_parent().noLiquidInThePot:
				raycastObj.get_parent().noLiquidInThePot = false
				newColor = leftHandObjLiquidColor
			else:
				newColor = ((leftHandObjLiquidColor * .5) + (colorOfTarget * .5))
			
		
			print(colorOfTarget,leftHandObjLiquidColor)
			#apply color
			raycastObj.get_parent().mats[0].get_active_material(0).albedo_color = newColor.clamp()
			raycastObj.get_parent().updateLiquids()
			SoundManager.play_sound_with_pitch(liquidPourInSFX, randf_range(1.1,1.7))
		hand1cooldown = true
		mouse1 = false
		await get_tree().create_timer(.2).timeout
		hand1cooldown = false
	if mouse2 == true and isLookingToItem == true and isRightHandOccupied == true and not mouse1 and raycastObj != null:
		if(len(raycastObj.get_parent().liquids) == 1 and len(rightHandObj.liquids) == 1) and raycastObj.get_parent().isPotionBottle:
			print("got it")
			colorOfTarget = Color(
				raycastObj.get_parent().liquids[0].x,
				raycastObj.get_parent().liquids[0].y,
				raycastObj.get_parent().liquids[0].z,
				raycastObj.get_parent().liquids[0].w)
			rightHandObjLiquidColor = Color(
				rightHandObj.liquids[0].x,
				rightHandObj.liquids[0].y,
				rightHandObj.liquids[0].z,
				rightHandObj.liquids[0].w)
			if raycastObj.get_parent().noLiquidInThePot:
				raycastObj.get_parent().noLiquidInThePot = false
				newColor = rightHandObjLiquidColor
			else:
				newColor = ((rightHandObjLiquidColor * .5) + (colorOfTarget * .5))
			print(colorOfTarget,leftHandObjLiquidColor)
			#apply color
			raycastObj.get_parent().mats[0].get_active_material(0).albedo_color = newColor.clamp()
			raycastObj.get_parent().updateLiquids()
			SoundManager.play_sound_with_pitch(liquidPourInSFX, randf_range(1.1,1.7))
		hand2cooldown = true
		mouse2 = false
		await get_tree().create_timer(.2).timeout
		hand2cooldown = false
func RaycastBook():
	if RaycastGetBook != null:
		if mouse1 == true and not mouse2 and RaycastGetBook.is_colliding():
			
			isBookOpen = true
			mouse1 = false
			BookUI.visible = true
			
			
		if mouse2 == true and not mouse1 and RaycastGetBook.is_colliding():
			
			isBookOpen = true
			mouse2 = false
			BookUI.visible = true
			
		
func ManageBook():
	if isBookOpen:
		if Input.is_action_pressed("back"):
			pass
		if Input.is_action_pressed("next"):
			pass
		if Input.is_action_pressed("exit"):
			BookUI.visible = false
			isBookOpen = false
