package puzzle1

import "core:os"
import "core:fmt"
import "core:strings"

main :: proc(){
	filepath := "./input.txt"
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
		fmt.println("Error Reading File!")
		return
	}
	defer delete(data, context.allocator)
	
	data_string := string(data)
	column_count := strings.index_rune(data_string, '\n')
	row_count := strings.count(data_string, "\n")
	row_count += 1
	
	table := make([dynamic][dynamic]rune, row_count)
	
	target_string := "XMAS"
	
	row_index := 0
	for input_char in data_string{
		if input_char == '\n'{
			row_index += 1
			continue
		}
		append(&table[row_index], input_char)
	}
	
	xmas_count := 0
	
	for x in 0..<column_count{
		for y in 0..<row_count{
			if table[y][x] == rune(target_string[0]){
				start_pos := [2]int{x, y}
				for dir in Direction_Vectors{
					xmas_valid := true
					test_pos := start_pos
					for target_char in target_string{
						if xmas_valid == false{
							break
						}
						if Is_On_Table(test_pos, &table) == false {
							xmas_valid = false
							continue
						}
						if target_char != table[test_pos[1]][test_pos[0]]{
							xmas_valid = false
							continue
						}
						test_pos += dir
					}
					if xmas_valid{
						xmas_count += 1
					}
				}
			}
		}
	}
	
	fmt.println(xmas_count)
}

Is_On_Table :: proc(pos : [2]int, table : ^[dynamic][dynamic]rune) -> bool{
	if pos[0] < 0 || pos[0] >= len(table[0]){
		return false
	}
	if pos[1] < 0 || pos[1] >= len(table){
		return false
	}
	return true
}

Direction :: enum{up, up_right, right, down_right, down, down_left, left, up_left}

Direction_Vectors :: [Direction][2]int{
	.up = { 0, -1 },
	.up_right = { 1, -1 },
	.right = { 1, 0 },
	.down_right = { 1, 1 },
	.down = { 0, 1 },
	.down_left = { -1, 1 },
	.left = { -1, 0 },
	.up_left = { -1, -1 }
}