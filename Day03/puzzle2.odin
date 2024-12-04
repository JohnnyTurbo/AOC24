package puzzle2

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"

main :: proc(){
	filepath := "./input.txt"
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
		fmt.println("Error Reading File!")
		return
	}
	defer delete(data, context.allocator)
	
	mul_token := "mul("
	do_token := "do()"
	dont_token := "don't()"
	mul_enabled := true
	sum := 0
	input_string := string(data)
	for character, it in input_string{
		cur_it := it
		is_valid := true
		
		do_valid := true
		for do_it in 0..<len(do_token){
			if input_string[cur_it] != do_token[do_it]{
				do_valid = false
				break
			}
			cur_it += 1
		}
		
		if do_valid{
			mul_enabled = true
			fmt.println("Enabled")
			continue
		}

		cur_it = it

		dont_valid := true
		for dont_it in 0..<len(dont_token){
			if input_string[cur_it] != dont_token[dont_it]{
				dont_valid = false
				break
			}
			cur_it += 1
		}
		
		if dont_valid{
			mul_enabled = false
			fmt.println("Disabled")
			continue
		}
		
		cur_it = it
		
		if !mul_enabled{
			continue
		}
		
		
		for mul_it in 0..<len(mul_token){
			if input_string[cur_it] != mul_token[mul_it]{
				is_valid = false
				break
			}
			cur_it += 1
		}
		
		if !is_valid{
			continue
		}
		
		number1_string_builder := strings.builder_make()
		number2_string_builder := strings.builder_make()
		
		for digit_index in 0..<4{
			next_char := rune(input_string[cur_it])
			if is_digit(next_char){
				if digit_index == 3{
					is_valid = false
					break
				}
				strings.write_rune(&number1_string_builder, next_char)
				cur_it += 1
				continue
			}
			if next_char == ','{
				if digit_index == 0{
					is_valid = false
					break
				}
				// fmt.println(cur_it)
				cur_it += 1
				// fmt.println(cur_it)
				break
			}
			
			is_valid = false
			break
		}
		
		if !is_valid{
			continue
		}
		
		for digit_index in 0..<4{
			next_char := rune(input_string[cur_it])
			if is_digit(next_char){
				if digit_index == 3{
					is_valid = false
					break
				}
				strings.write_rune(&number2_string_builder, next_char)
				cur_it += 1
				continue
			}
			if next_char == ')'{
				if digit_index == 0{
					is_valid = false
					break
				}
				cur_it += 1
				break
			}
			
			is_valid = false
			break
		}
		
		number1_string := strings.to_string(number1_string_builder)
		number2_string := strings.to_string(number2_string_builder)
		
		if !is_valid{
			continue
		}
		
		slice := input_string[it:cur_it]
		fmt.println(slice)
		
		number1, parse1_ok := strconv.parse_int(number1_string)
		number2, parse2_ok := strconv.parse_int(number2_string)
		
		product := number1 * number2
		sum += product
	}
	fmt.println(sum)
}

is_digit :: proc(s: rune) -> bool{
	if  s == '0' ||	
		s == '1' ||
		s == '2' ||
		s == '3' ||
		s == '4' ||
		s == '5' ||
		s == '6' ||
		s == '7' ||
		s == '8' ||
		s == '9' {
		return true
	}
	else{
		return false
	}
}