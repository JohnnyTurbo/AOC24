package puzzle2

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:math"

main :: proc(){
	filepath := "./input.txt"
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
		fmt.println("Error reading file!")
		return
	}
	defer delete(data, context.allocator)
	
	safe_reports := 0
	it := string(data)
	for report in strings.split_lines_iterator(&it){
		levels : [dynamic]int
		level_strings := strings.split(report, " ", context.allocator)
		for level_string in level_strings{
			level, ok := strconv.parse_int(level_string)
			append(&levels, level)
		}
		
		level0 := levels[0]
		level1 := levels[1]
		
		is_increasing := level0 < level1
		
		report_safe := true
		previous_level := level0
		for level, i in levels{
			if i == 0{
				continue
			}
			if level == previous_level{
				report_safe = false
				break
			}
			difference := level - previous_level
			if is_increasing && (difference < 1 || difference > 3){
				report_safe = false
				break
			}
			if !is_increasing && (difference < -3 || difference > -1){
				report_safe = false
				break
			}
			previous_level = level
		}
		
		if(!report_safe){
			for remove_index in 0..<len(levels){
				first_index := remove_index == 0 ? 1 : 0
				first_level := levels[first_index]
				second_index := remove_index < 2 ? 2 : 1
				second_level := levels[second_index]
				
				if first_level == second_level{
					continue
				}
				is_increasing = first_level < second_level
				
				report_safe = true
				previous_level = first_level
				for level, i in levels{
					if i == first_index{
						continue
					}
					if i == remove_index{
						continue
					}
					if level == previous_level{
						report_safe = false
						break
					}
					difference := level - previous_level
					if is_increasing && (difference < 1 || difference > 3){
						report_safe = false
						break
					}
					if !is_increasing && (difference < -3 || difference > -1){
						report_safe = false
						break
					}
					previous_level = level
				}
				
				if report_safe{
					/*
					fmt.println(levels)
					fmt.println(remove_index)
					fmt.println(is_increasing)
					*/
					break
				}
			}
		}
		
		if report_safe{
			safe_reports += 1
			// fmt.println(levels)
		}
	}
	
	fmt.println(safe_reports)
}