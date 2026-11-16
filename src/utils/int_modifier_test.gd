# GdUnit generated TestSuite
class_name IntModifierTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

# TestSuite generated from
const __source: String = "res://src/utils/int_modifier.gd"


func test_no_modifiers() -> void:
	var im: IntModifier = IntModifier.new(3).with_modifiers([])

	assert_int(im.peek()).is_equal(3)
	assert_int(im.next()).is_equal(3)
	assert_int(im.peek()).is_equal(3)
	assert_int(im.next()).is_equal(3)


func test_custom_modifiers() -> void:
	const base_value: int = 5
	const modifiers: Array[int] = [-3, 6, -5]  # Random order.
	const expected: Array[int] = [0, 2, 11]  # Sorted.

	var im: IntModifier = IntModifier.new(base_value).with_modifiers(modifiers)
	var num_tests: int = expected.size()

	var actuals: Array[int]
	for i: int in num_tests:
		actuals.append(im.next())

	actuals.sort()
	assert_array(actuals).is_equal(expected)


func test_custom_modifiers_twice() -> void:
	const base_value: int = 5
	const modifiers: Array[int] = [-3, 6, -5]  # Random order.
	const expected: Array[int] = [0, 2, 11]  # Sorted.

	var im: IntModifier = IntModifier.new(base_value).with_modifiers(modifiers)
	var num_tests: int = expected.size()

	var actuals: Array[int]
	for i: int in num_tests:
		actuals.append(im.next())

	actuals.sort()
	assert_array(actuals).is_equal(expected)

	actuals.clear()
	for i: int in num_tests:
		actuals.append(im.next())

	actuals.sort()
	assert_array(actuals).is_equal(expected)
