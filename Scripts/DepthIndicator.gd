extends Control

const maxSpeed = 108

var active = false

@export var player: CharacterBody2D

@onready var startingText: Label = $"../../StartingText"
@onready var infoItems: Control = $".."

@onready var textureProgressBar: TextureProgressBar = $TextureProgressBar
@onready var depth: Label = $"../Depth"
@onready var speed: Label = $"../Speed"
@onready var dial: TextureRect = $"../Dial"
@onready var fuelBar: TextureProgressBar = $"../FuelBar"
@onready var boostFuelBar: TextureProgressBar = $"../BoostFuelBar"
@onready var attitudeBg: TextureRect = $"../AttitudeBG"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fuelBar.max_value = player.fuel
	fuelBar.value = player.fuel
	
	infoItems.position = Vector2(1920, 0)

	var tween = get_tree().create_tween().set_loops(int(INF))
	tween.tween_property(startingText, "rotation_degrees", -5, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(startingText, "rotation_degrees", 5, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	textureProgressBar.value = player.position.y
	fuelBar.value = player.fuel
	boostFuelBar.value = player.boost
	attitudeBg.rotation = player.rotation
	
	depth.text = "Depth: " + str(round(player.position.y) / 10) + "m" 
	speed.text = str(round(sqrt(player.velocity.x ** 2.0 + player.velocity.y ** 2.0) / 10.0 * 3.6)) + " km / hr"
	#dial.rotation = -117.5 + sqrt(player.velocity.x ** 2.0 + player.velocity.y ** 2.0) / 10.0 * 3.6
