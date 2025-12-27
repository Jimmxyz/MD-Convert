require 'colorize'
ver = "0.1"
input_array = ARGV

def showHelp()
  puts "\nMD Convert".colorize(:blue) + "\n\nGeneral"
  puts "-------\n" + "-h".colorize(:blue) + " or " + "--help".colorize(:blue) + " to show help"
  puts "--version".colorize(:blue) + " to show version"
  puts "\nConverting\n----------"
  puts "<the .md file path>".colorize(:yellow) + " to start the convertion"
  puts "<the .md file path>".colorize(:yellow) + " -s:".colorize(:blue) + "<the folder where you want to save the future .html file>".colorize(:green) + " to start the convertion and save in the choosen folder"
  puts "<the .md file path>".colorize(:yellow) + " -s:".colorize(:blue) + "<the .html file you want to save in>".colorize(:green) + " to start the convertion and to save in the choosen html file"
  puts "Note : you don't need to use the 2 last command the first will do it"
  puts "\nSettings\n----------"
  puts "-b".colorize(:blue) + " to translate only in basic Markdown"
  puts ""
end

def getFile(path)
  if File.file?(path) && File.extname(path) == ".md"
    puts "The Markdown File : #{File.basename(path)} was founded...".colorize(:green)
  elsif File.file?(path)
    puts "Error".colorize(:background => :red) + ": #{File.basename(path)} is not a markdown file (.md)".colorize(:red)
    return 1
  else
    puts "Error".colorize(:background => :red) + ": The file doesn't exist".colorize(:red)
    return 1
  end
  begin
    data = File.read(path)
  rescue StandardError => e
    puts "Error".colorize(:background => :red) + ": Can't read the file : #{e}".colorize(:red)
  end
end

if input_array.length <= 0
  showHelp()
end

for i in input_array
  if i == "--version"
    puts "\nMD Convert Version #{ver}".colorize(:color => :blue, :mode => :bold)
    puts ""
    break
  elsif i == "--help" || i == "-h"
    showHelp()
  elsif i[0] == "-"
    puts "Invalid argument: #{i}".colorize(:color => :red, :mode => :bold)
    break
  else
    getFile(i)
  end
end
