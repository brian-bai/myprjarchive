#!/usr/bin/env ruby

class TipManager

  TIP_FILE = '/Users/haku/mybin/repo/tips.txt'

  def initialize
    File.open(TIP_FILE,'w') if !File.exists?(TIP_FILE)
  end
  def add tip
    File.open(TIP_FILE, 'a') do |f|
      f.puts tip
    end
  end

  def search q
    tips.split("\n").each do |tip|
      puts tip if tip.include? q
    end
  end

  def list
    puts tips
  end

  def tips
    File.read(TIP_FILE)
  end
end

tm = TipManager.new

ARGV << '--help' if ARGV.empty?

aliases = {
  "c"  => "create",
  "s"  => "search",
  "l" => "list"
}

command = ARGV.shift
command = aliases[command] || command

second_par = ARGV.shift

case command
when 'create'
  if second_par
    tm.add second_par
  else
    puts "input tip content please."
  end
when 'search'
  tm.search second_par if second_par

when 'list'
  tm.list

else
  puts "Error: Command not recognized" unless %w(-h --help).include?(command)
  puts <<-EOT
Usage: tip COMMAND [ARGS]

The common tip commands are:
 create     Create a new tip (short-cut alias: "c")
 search     Search the tip (short-cut alias: "s")
 list       List the tips (short-cut alias: "l")

  EOT
  exit(1)
end



