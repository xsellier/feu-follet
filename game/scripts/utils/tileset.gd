
static func build_lights(parent, tilemap):
  var cell_positions = tilemap.get_used_cells()

  for pos in cell_positions:
    var tile_id = tilemap.get_cellv(pos)
    var tile_name = tilemap.get_tileset().tile_get_name(tile_id)
    if tile_name == "window":
      var light = load('res://scenes/tileset/window.scn').instance()

      parent.add_child(light)
      light.set_pos(pos * tilemap.get_cell_size() + tilemap.get_cell_size() * 2.0)