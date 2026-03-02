extends PointLight2D

@export var player: CharacterBody2D

var lightMin = 1060
var lightMax = 6000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position = Vector2(player.position.x, player.position.y + 50)
	energy = clamp((player.position.y - lightMin) / 61300.0, 0, 16)
	#energy = -player.position.y
