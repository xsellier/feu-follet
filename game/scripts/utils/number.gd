const range_factor = 1000
const units = ['', 'K', 'M', 'B', 'G']

static func format(number):
  var unit_index = 0
  var format_text = '%d %s'
  var ratio = 1

  for index in range(0, units.size()):
    var computed_ratio = pow(range_factor, index)

    if abs(number) > computed_ratio:
      ratio = computed_ratio
      unit_index = index

      if index > 0:
        format_text = '%.3f %s'
  
  return format_text % [(number / ratio), units[unit_index]]

static func random(min_value, max_value):
  randomize()

  return randi() % int(max_value - min_value) + int(min_value)

static func randomf(min_value, max_value):
  randomize()

  return randf() * float(max_value - min_value) + float(min_value)
