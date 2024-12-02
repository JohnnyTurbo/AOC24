package puzzle2

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"
import "core:math"

main :: proc(){
	fmt.println("Hello Advent")
	filepath := "./input.txt"
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
		fmt.println("Not Read File!")
		return
	}
	defer delete(data, context.allocator)
	
	col1 : [dynamic]int
	col2 : [dynamic]int
	
	it := string(data)
	for line in strings.split_lines_iterator(&it){
		line_numbers := strings.split(line, "   ", context.allocator)
		number1, parse1_ok := strconv.parse_int(line_numbers[0])
		number2, parse2_ok := strconv.parse_int(line_numbers[1])
		append(&col1, number1)
		append(&col2, number2)
	}
	slice.sort(col1[:])
	slice.sort(col2[:])
	
	similarity := 0
	
	/*
	fmt.println(col1)
	fmt.println()
	fmt.println(col2)
	fmt.println()
	*/
	
	for num1 in col1{
		count := 0
		for num2 in col2{
			if num2 > num1{
				break
			}
			if num2 == num1{
				count += 1
			}
		}
		similarity += num1 * count
	}
	
	fmt.println(similarity)
}