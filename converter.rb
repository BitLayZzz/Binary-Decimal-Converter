# Quic binary number converter script in ruby

########### Two's Complement Logic ##########

def add_bit(working_arr, og_bin_arr)
  working_arr[-1] += 1

  (0...og_bin_arr.length).each do |i|
    if working_arr[-i - 1] > 1

      working_arr[-i - 2] += 1

      working_arr[-i - 1] = 0
    end
  end

  working_arr
end

def bit_flip(working_arr, og_bin_arr)
  working_arr.each_index do |b|

    working_arr[b] == 0 ? working_arr[b] = 1 : working_arr[b] = 0

  end

  twos_comp_arr = add_bit(working_arr, og_bin_arr)

  twos_comp_arr
end

############# Decimal to Binary ############

def dec_twos_complement(og_bin_arr, og_num)

  working_arr = Array.new(og_bin_arr)

  loop do
    working_arr.prepend(0)

    break if working_arr.length == 16
  end

  if og_num < 0
    final_result = bit_flip(working_arr, og_bin_arr)
  else
    final_result = working_arr
  end

  final_result
end

def dec_2_bin(num)
  bin_arr = Array.new

  new_num = num.to_i.abs

  loop do
    remainder = new_num % 2

    new_num = new_num / 2

    bin_arr.push(remainder)

    break if new_num == 0
  end

  bin_arr.reverse!

  twos_comp_result = dec_twos_complement(bin_arr, num)

  loop do
    break if twos_comp_result.first == 1

    twos_comp_result.delete_at(0)
  end

  twos_comp_result
end

########### Binary to Decimal ############

def sign_bit?(og_arr)
  sign = ""

  og_arr.first == 0 ? sign = "+" : sign = "-"

  sign
end

def bin_twos_complement(bin)
  bin_arr = bin.to_s.split('').map(&:to_i)

  loop do
    break if bin_arr.length >= 16

    bin_arr.unshift(0)
  end

  bin_arr
end

def bin_2_dec_math(bin_arr)
  new_num = 0

  bin_arr.each_with_index do |digit, position|

    new_num = new_num + (digit * (2 ** (bin_arr.length - (position + 1))))

  end

  new_num
end

def bin_2_dec(bin_arr, sign_bit)
  dec_num = 0

  working_arr = Array.new(bin_arr)

  if sign_bit == '+'
    dec_num = bin_2_dec_math(bin_arr)

    return dec_num
  else
    bin_arr = bit_flip(working_arr, bin_arr)

    dec_num = bin_2_dec_math(bin_arr)

    return dec_num - (dec_num * 2)
  end

end

def bin_number?(num)
  num_split = num.to_s.split('')

  checked_num = num

  num_split.each do |digit|

    return -1 if digit.to_i < 0 || digit.to_i > 1

  end

  checked_num.to_i
end

############# Main ##############

puts "=> Please choose (1 or 2)"
puts "=> 1.) Decimal to Binary?"
puts "=> 2.) Binary to Decimal?"

user_choice = gets.chomp.to_i

case user_choice
when 1
  puts "Decimal to Binary"
  printf "=> Enter in a number:  "

  dec_num = gets.chomp.to_i

  bin_num = dec_2_bin(dec_num)

  puts "=> Decimal: #{dec_num}\n=> Binary: #{bin_num.join}"

when 2
  puts "Binary to Decimal"
  printf "=> Enter in a number:  "

  bin_num = gets.chomp.to_i

  binary_number_check = bin_number?(bin_num)

  bin_arr = bin_twos_complement(bin_num)

  if binary_number_check < 0
    puts "Number is not a binary number..."

    sleep 1

    puts "Ending Program..."
  elsif bin_arr.length > 16
    puts "Number is too large!"

    sleep 1

    puts "Ending Program..."
  else
    sign_bit = sign_bit?(bin_arr)

    dec_num = bin_2_dec(bin_arr, sign_bit)

    puts "=> Binary: #{bin_num}\n=> Decimal: #{dec_num}"

    puts "You made it!!!"
  end

end

