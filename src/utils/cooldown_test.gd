# GdUnit generated TestSuite
class_name CooldownTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

# TestSuite generated from
const __source: String = "res://src/utils/cooldown.gd"


func test_tick_no_modifiers() -> void:
	var cooldown: Cooldown = Cooldown.new(3)
	assert_bool(cooldown.tick()).is_equal(false)
	assert_bool(cooldown.tick()).is_equal(false)
	assert_bool(cooldown.tick()).is_equal(false)
	assert_bool(cooldown.tick()).is_equal(true)


func test_stays_true_until_reset() -> void:
	var cooldown: Cooldown = Cooldown.new(2)
	cooldown.tick()
	cooldown.tick()

	assert_bool(cooldown.tick()).is_equal(true)
	assert_bool(cooldown.tick()).is_equal(true)


func test_false_after_reset() -> void:
	var cooldown: Cooldown = Cooldown.new(2)
	cooldown.tick()
	cooldown.tick()

	cooldown.reset()
	assert_bool(cooldown.tick()).is_equal(false)


func test_false_after_early_reset() -> void:
	var cooldown: Cooldown = Cooldown.new(67)
	cooldown.tick()
	cooldown.tick()

	cooldown.reset()
	assert_bool(cooldown.tick()).is_equal(false)


func test_one_tick() -> void:
	var cooldown: Cooldown = Cooldown.new(1)
	assert_bool(cooldown.tick()).is_equal(false)
	assert_bool(cooldown.tick()).is_equal(true)

	cooldown.reset()
	assert_bool(cooldown.tick()).is_equal(false)
	assert_bool(cooldown.tick()).is_equal(true)


func test_zero_ticks() -> void:
	var cooldown: Cooldown = Cooldown.new(0)
	assert_bool(cooldown.tick()).is_equal(true)

	cooldown.reset()
	assert_bool(cooldown.tick()).is_equal(true)


func test_negative_ticks() -> void:
	var cooldown: Cooldown = Cooldown.new(-1)
	assert_bool(cooldown.tick()).is_equal(true)

	cooldown.reset()
	assert_bool(cooldown.tick()).is_equal(true)


func test_tick_custom_modifier() -> void:
	var cooldown: Cooldown = Cooldown.new(3).with_modifiers([-1])
	assert_bool(cooldown.tick()).is_equal(false)
	assert_bool(cooldown.tick()).is_equal(false)
	assert_bool(cooldown.tick()).is_equal(true)

	cooldown.reset()
	assert_bool(cooldown.tick()).is_equal(false)
	assert_bool(cooldown.tick()).is_equal(false)
	assert_bool(cooldown.tick()).is_equal(true)


func test_tick_custom_modifiers() -> void:
	const base_ticks: int = 5
	var modifiers: Array[int] = [-2, -1, 0, 1, 2]
	var expected: Array[int]
	expected.assign(modifiers.map(func(modifier: int) -> int: return base_ticks + modifier))
	var cooldown: Cooldown = Cooldown.new(base_ticks).with_modifiers(modifiers)

	var tick_counts: Array[int]

	for i: int in modifiers.size():
		var curr_ticks: int = _count_ticks(cooldown)
		tick_counts.append(curr_ticks)
		cooldown.reset()

	tick_counts.sort()
	assert_array(tick_counts).is_equal(expected)


func test_tick_range_mode() -> void:
	const low: int = 2
	const high: int = 4
	const num_tests: int = 10
	var cooldown: Cooldown = Cooldown.new(low, high)

	for i: int in num_tests:
		var curr_ticks: int = _count_ticks(cooldown)
		assert_int(curr_ticks).is_greater_equal(low)
		assert_int(curr_ticks).is_less_equal(high)
		cooldown.reset()


func _count_ticks(cooldown: Cooldown) -> int:
	var curr_ticks: int = 0
	while !cooldown.peek():
		cooldown.tick()
		curr_ticks += 1
	return curr_ticks
