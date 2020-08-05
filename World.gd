extends Spatial


const Tile = {
    PLANT = 96,
	FLOWER = 119,
    DIRT = 132,
    GRASS = 128,
}
	
var tiles = []
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var grid: PackedScene = preload("res://Grid.tscn")
var rng = RandomNumberGenerator.new()
export var mapSeed = 'none'
var world = {};

const tileBase = preload("tile.gd") # Relative path

export var noiceOctaves = 2;
export var noicePeriod = 20;
export var noicePersistance = 2.0;
# Called when the node enters the scene tree for the first time.
func _ready():
	if (mapSeed != 'none'):
		rng.set_seed(mapSeed.hash())
	else:
		rng.randomize()
		
	var noise = OpenSimplexNoise.new()
	rng.set_seed(mapSeed.hash())
	
	# Configure
	noise.seed = rng.randi()
	noise.octaves = noiceOctaves
	noise.period = noicePeriod
	noise.persistence = noicePersistance
	var noise_image = noise.get_image(50, 50)
	noise_image.lock();

	for x in range(50):
		tiles.append([])
		for y in range(50):
			tiles[x].append("")
			var tile = round(noise_image.get_pixel(x, y).v * 10);
			
			var newTile = tileBase.new()
			if tile < 5:
				newTile.tile = Tile.GRASS
			else:
				newTile.tile = Tile.DIRT
			
			tiles[x][y] = newTile
			
			
	render()
			
	pass # Replace with function body.


func render():
	var newGrid :Spatial = grid.instance()
	var floorGrid :GridMap = newGrid.get_node('Floor')
	var objectGrid :GridMap = newGrid.get_node('Objects')
	for x in range(50):	
		for y in range(50):
			floorGrid.set_cell_item(x -25, 0, y-25, tiles[x][y].tile)
			var rand = rng.randi_range(0, 10)
			if (rand > 8):
				objectGrid.set_cell_item(x -25, 0, y-25, Tile.PLANT)
			if (rand <= 1):
				objectGrid.set_cell_item(x -25, 0, y-25, Tile.FLOWER)
				
			
	get_node("Gridholder").add_child(newGrid)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
