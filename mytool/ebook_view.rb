#!/usr/bin/env ruby

EBOOK_HOME="/Users/haku/Dropbox/books"
if $0 == __FILE__
  ebook_types = []
  ebook_type = ARGV[0]
  if !ebook_type
    puts "what your want to read?"
    ebook_type = STDIN.gets.chomp
  end
  ebook_types << ebook_type << ebook_type.capitalize
  book_list = []
  i = 0
  ebook_types.each do |type|
    Dir.glob("#{EBOOK_HOME}/**/**#{type}*").each do |f|
      i = i + 1
      puts "#{i}: #{File.basename(f)}"
      book_list << f
    end
  end
  
  if i == 0
    puts "no book found"
    exit
  end
  index = -1
  until (1..i).include? index
    puts "select in the book list from 1 to #{i}"
    puts "input 0 to exit"
    index = STDIN.gets.chomp.to_i
    exit if index == 0
  end
  exec "open '#{book_list[index - 1]}'"
end
