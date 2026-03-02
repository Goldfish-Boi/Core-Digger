extends CharacterBody2D

var AngularVelocity = 0
var topSpeed = 0

var active = false
var AboveGround = false
var endingTriggered = false
var gameOver = false

#//////////////////////////// REFERENCES ////////////////////////////#

@export var fuel: int
@export var boost: int
@export var money: int
@onready var player: CharacterBody2D = $"."
@onready var cover: ColorRect = $CanvasLayer/Control/Cover
@onready var info: Control = $CanvasLayer/Control/Info
@onready var line2d: Line2D = $Line2D

@onready var boostFuelBar: TextureProgressBar = $CanvasLayer/Control/Info/BoostFuelBar
@onready var fuelBar: TextureProgressBar = $CanvasLayer/Control/Info/FuelBar

@onready var startingText: Label = $CanvasLayer/Control/StartingText
@onready var infoItems: Control = $CanvasLayer/Control/Info
@onready var dial: TextureRect = $CanvasLayer/Control/Info/Dial

@onready var endScreenHud: Control = $CanvasLayer/Control/EndScreen
@onready var final_depth: Label = $CanvasLayer/Control/EndScreen/FinalDepth
@onready var top_speed: Label = $CanvasLayer/Control/EndScreen/TopSpeed
@onready var money_earned: Label = $CanvasLayer/Control/EndScreen/MoneyEarned

@onready var returnToSurface: Button = $CanvasLayer/Control/EndScreen/ReturnToSurface

@onready var shop: Control = $CanvasLayer/Control/Shop
@onready var current_money: Label = $CanvasLayer/Control/Shop/CurrentMoney
@onready var startNextRound: Button = $CanvasLayer/Control/Shop/StartNextRound

@onready var upgradeFuel: Button = $CanvasLayer/Control/Shop/UpgradeFuel
@onready var upgradeBoostFuel: Button = $CanvasLayer/Control/Shop/UpgradeBoostFuel
@onready var upgradeBoostStrength: Button = $CanvasLayer/Control/Shop/UpgradeBoostStrength
@onready var upgradeFriction: Button = $CanvasLayer/Control/Shop/UpgradeFriction
@onready var upgradeAcceleration: Button = $CanvasLayer/Control/Shop/UpgradeAcceleration
@onready var upgradeSpeed: Button = $CanvasLayer/Control/Shop/UpgradeSpeed
@onready var upgradeImpulse: Button = $CanvasLayer/Control/Shop/UpgradeImpulse
@onready var free_money: Button = $CanvasLayer/Control/Shop/FreeMoney

#//////////////////////////// UPGRADABLES ////////////////////////////#
var MaxFuel = 100
var SPEED = 300
var Acceleration = 100

var MaxBoostFuel = boost
var BoostMultiplier = 0.75

var intitialImpulse = 0
var friction = 100

#//////////////////////////// COSTS ////////////////////////////#
var fuelLevel = 1
var FuelUpgradeCost = 100

var boostFuelLevel = 0
var BoostFuelUpgradeCost = 1000

var boostStrengthLevel = 1
var BoostStrengthCost = 2000

var frictionLevel = 1
var frictionUpgradeCost = 1500

var impulseLevel = 0
var impulseUpgradeCost = 2000

var accelerationLevel = 1
var accelerationUpgradeCost = 1500

var speedLevel = 1
var speedUpgradeCost = 1500

#//////////////////////////// MAIN ////////////////////////////#

func _ready() -> void:
	print("I... am Pibble!")
	fuel = MaxFuel
	shop.position = Vector2(0, -3000)
	
	upgradeBoostFuel.text = "Boost Fuel [lvl 0] $" + str(BoostFuelUpgradeCost)
	upgradeFuel.text = "Fuel [lvl 1] $" + str(FuelUpgradeCost)
	upgradeFriction.text = "Friction [lvl 1] $" + str(frictionUpgradeCost)
	upgradeSpeed.text = "Speed [lvl 1] $" + str(speedUpgradeCost)
	upgradeAcceleration.text = "Acceleration [lvl 1] $" + str(accelerationUpgradeCost)
	upgradeImpulse.text = "Initial Impulse [lvl 0] $" + str(impulseUpgradeCost)
	upgradeBoostStrength.text = "Boost Strength [lvl 1] $" + str(BoostStrengthCost)
	
	fuelBar.max_value = MaxFuel
	boostFuelBar.max_value = boost

#/////////////////// SHOP FUNCTIONS ///////////////////#

func flashCost():
	current_money.label_settings.font_color = Color(1, 0, 0)
	
	var fadeToBlackTween = get_tree().create_tween()
	fadeToBlackTween.tween_property(current_money.label_settings, "font_color", Color(1, 1, 1), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

func fuelUpgrade():
	if money < FuelUpgradeCost:
		flashCost()
		return
		
	money -= FuelUpgradeCost
	current_money.text = "$" + str(money)
	
	MaxFuel *= 2
	FuelUpgradeCost *= 4
	fuelLevel += 1
	
	upgradeFuel.text = "Fuel [lvl " + str(fuelLevel) + "] $" + str(FuelUpgradeCost)
	
func speedUpgrade():
	if money < speedUpgradeCost:
		flashCost()
		return
		
	money -= speedUpgradeCost
	current_money.text = "$" + str(money)
	
	SPEED += 100
	speedUpgradeCost *= 2
	speedLevel += 1
	
	upgradeSpeed.text = "Speed [lvl " + str(speedLevel) + "] $" + str(speedUpgradeCost)
	
func accelerationUpgrade():
	if money < accelerationUpgradeCost:
		flashCost()
		return
		
	money -= accelerationUpgradeCost
	current_money.text = "$" + str(money)
	
	Acceleration += 50
	accelerationUpgradeCost *= 2
	accelerationLevel += 1
	
	upgradeAcceleration.text = "Acceleration [lvl " + str(accelerationLevel) + "] $" + str(accelerationUpgradeCost)
	
func boostStrengthUpgrade():
	if money < BoostStrengthCost:
		flashCost()
		return
		
	money -= BoostStrengthCost
	current_money.text = "$" + str(money)
	
	BoostMultiplier += 0.75
	BoostStrengthCost *= 4
	boostStrengthLevel += 1
	
	upgradeBoostStrength.text = "Acceleration [lvl " + str(boostStrengthLevel) + "] $" + str(BoostStrengthCost)
	
func impulseUpgrade():
	if money < impulseUpgradeCost:
		flashCost()
		return
		
	money -= impulseUpgradeCost
	current_money.text = "$" + str(money)
	
	intitialImpulse += 150
	impulseUpgradeCost *= 4
	impulseLevel += 1
	
	upgradeImpulse.text = "Initial Impulse [lvl " + str(impulseLevel) + "] $" + str(impulseUpgradeCost)
	
func frictionUpgrade():
	if frictionLevel == 999:
		return
	
	if money < BoostFuelUpgradeCost:
		flashCost()
		return
		
	money -= BoostFuelUpgradeCost
	current_money.text = "$" + str(money)
	
	boostFuelLevel += 1
	
	friction -= 10
	
	if friction == 20:
		frictionLevel = 999
		upgradeFriction.text = "Friction [lvl MAX]" 
	else:
		frictionLevel += 1
		frictionUpgradeCost *= 4
		upgradeFriction.text = "Friction [lvl " + str(frictionLevel) + "] $" + str(frictionUpgradeCost)
	
func boostFuelUpgrade():
	if money < BoostFuelUpgradeCost:
		flashCost()
		return
	
	money -= BoostFuelUpgradeCost
	current_money.text = "$" + str(money)
	
	boostFuelLevel += 1
	
	if boostFuelLevel == 1:
		MaxBoostFuel += 100
		boostFuelBar.visible = true
		upgradeBoostStrength.visible = true
	else:
		MaxBoostFuel *= 4

	BoostFuelUpgradeCost *= 4
	
	upgradeBoostFuel.text = "Boost Fuel [lvl " + str(boostFuelLevel) + "] $" + str(BoostFuelUpgradeCost)
	
func giveFreeMoney():
	money += 10000
	current_money.text = "$" + str(money)

#/////////////////// MAIN FUNCTIONS ///////////////////#

func reset():
	var tweenPlayerShop = get_tree().create_tween()
	tweenPlayerShop.tween_property(shop, "position", Vector2(0, -3000), 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	
	startingText.visible = true
	
	active = false
	AboveGround = false
	endingTriggered = false
	gameOver = false
	topSpeed = 0
	
	fuel = MaxFuel
	boost = MaxBoostFuel
	
	fuelBar.max_value = fuel
	
	boostFuelBar.max_value = boost
	boostFuelBar.value = boost

func resetToShop():
	if active == true:
		return
		
	cover.color = Color(0, 0, 0, 0)
	endScreenHud.position = Vector2(0, 3000)
	
	var tweenPlayerPos = get_tree().create_tween()
	tweenPlayerPos.tween_property(self, "position", Vector2.ZERO, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	
	var tweenPlayerRot = get_tree().create_tween()
	tweenPlayerRot.tween_property(self, "rotation_degrees", 0, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	
	await get_tree().create_timer(1).timeout
	
	current_money.text = "$" + str(money)
	
	var tweenPlayerShop = get_tree().create_tween()
	tweenPlayerShop.tween_property(shop, "position", Vector2.ZERO, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	
	upgradeFuel.pressed.connect(fuelUpgrade)
	upgradeBoostFuel.pressed.connect(boostFuelUpgrade)
	upgradeFriction.pressed.connect(frictionUpgrade)
	upgradeImpulse.pressed.connect(impulseUpgrade)
	upgradeSpeed.pressed.connect(speedUpgrade)
	upgradeAcceleration.pressed.connect(accelerationUpgrade)
	upgradeBoostStrength.pressed.connect(boostStrengthUpgrade)
	free_money.pressed.connect(giveFreeMoney)
	
	startNextRound.pressed.connect(reset)

func endScreen():
	cover.color = Color(0, 0, 0, 0)
	endScreenHud.position = Vector2(0, 3000)
	
	top_speed.text = "Top speed: " + str(round(topSpeed)) + " km / hr [$" + str(round(0.01 * round(topSpeed) ** 2)) +"]"
	final_depth.text = "Final depth: " + str(round(player.position.y) / 10) + "m [$" + str(round(0.001 * (round(player.position.y) / 10) ** 2)) + "]"
	money_earned.text = "Total Money Earned: $" + str(round(player.position.y) / 10 + round(topSpeed) / 10)
	
	money += round((0.001 * (round(player.position.y) / 10) ** 2)) + round((0.01 * round(topSpeed) ** 2))
	
	print(money)
	
	var tweenBG = get_tree().create_tween()
	tweenBG.tween_property(cover, "color", Color(0, 0, 0, 0.75), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	
	var tweenInfo = get_tree().create_tween()
	tweenInfo.tween_property(info, "position", Vector2(1920, 0), 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	
	await get_tree().create_timer(0.5).timeout
	
	var tweenScreen = get_tree().create_tween()
	tweenScreen.tween_property(endScreenHud, "position", Vector2.ZERO, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	
	returnToSurface.pressed.connect(resetToShop)
	
func _physics_process(delta: float) -> void:
	if not active:
		if gameOver == false and Input.is_action_pressed("Enter") == true:
			velocity.y += intitialImpulse
			active = true
			startingText.visible = false
			
			var tween = get_tree().create_tween()
			tween.tween_property(infoItems, "position", Vector2(0, 0), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		else:
			return
	
	if gameOver == true:
		return
		
	if visible == false:
		velocity = Vector2.ZERO
		return
	
	if position.y < 0:
		AboveGround = true
		line2d.active = false
		
		velocity += get_gravity() * delta * 0.15
	else:
		AboveGround = false
		line2d.active = true

	# Handle jump.
	var direction := Input.get_axis("TurnClockwise", "TurnCounterClockwise")
	
	if direction and velocity != Vector2.ZERO:
		AngularVelocity = move_toward(AngularVelocity, 5 * direction, delta * 3)
	else:
		AngularVelocity = move_toward(AngularVelocity, 0, delta * 5)
		
	if AngularVelocity:
		rotation += AngularVelocity * delta
	
	if Input.is_action_pressed("Boost"):
		if boost != 0 and !AboveGround:
			if velocity.length() / 10 * 3.6 < 0.5 * SPEED + (0.5 * SPEED * BoostMultiplier):
				velocity.x += Vector2.UP.rotated(rotation).x * -SPEED * delta * (Acceleration * (3.0/100.0))
				velocity.y += Vector2.UP.rotated(rotation).y * -SPEED * delta * (Acceleration * (3.0/100.0))
				
			boost -= 1
	
	if Input.is_action_pressed("Drill") and !AboveGround and fuel != 0:
		velocity.x = move_toward(velocity.x, Vector2.UP.rotated(rotation).x * -SPEED, delta * Acceleration)
		velocity.y = move_toward(velocity.y, Vector2.UP.rotated(rotation).y * -SPEED, delta * Acceleration)
		
		fuel -= 1
		#velocity = Vector2.UP.rotated(rotation) * -20
	else:
		if !AboveGround and not endingTriggered == true:
			velocity.x = move_toward(velocity.x, 0, delta * friction)
			velocity.y = move_toward(velocity.y, 0, delta * friction)
			
	if fuel == 0 and boost == 0 and velocity == Vector2.ZERO:
		if gameOver == false:
			gameOver = true
			active = false
			endScreen()
	
	dial.rotation_degrees = clamp(-117.5 + (velocity.length() / 10.0 * 3.6) / ((SPEED * (9.0/25.0)) / 183.0), -117.5, 117.5)
	
	if player.position.y >= 61370:
		if endingTriggered == false:
			endingTriggered = true
			
			var tween = get_tree().create_tween()
			tween.tween_property(cover, "color", Color(1, 1, 1, 1), 5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
			
			await get_tree().create_timer(10).timeout
			
			get_tree().change_scene_to_file("res://Scenes/win.tscn")
		
	if velocity.length() / 10.0 * 3.6 > topSpeed:
		topSpeed = velocity.length() / 10.0 * 3.6
	#print(rotation)

	move_and_slide()
