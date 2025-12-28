require 'colorize'
require 'rbconfig'
require_relative 'emoji'

def main()
  input_array = ARGV
  ver = "0.1"
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
end

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
    html = analyse(data,path)
    newPath = File.basename(path, File.extname(path)) + ".html"

    File.open(newPath, "w") do |file|
      file.puts html
    end
    case RbConfig::CONFIG['host_os']
    when /darwin/  # macOS
      system("open", newPath)
    when /linux/
      system("xdg-open", newPath)
    when /mswin|mingw|cygwin/
      system("start", newPath)
    else
      puts "unsupported OS"
    end
  rescue StandardError => e
    puts "Error".colorize(:background => :red) + ": Conversion error : #{e}".colorize(:red)
    return
  end
end

def analyse(data,path)
  data = codeAnalyse(data)

  cutData = data.split("\n")
  titleData = []
  lastLineTitle = ""

  cutData.each do |line|
    titleData << titleAnalyse(line, lastLineTitle)
    lastLineTitle = line
  end

  puts "[1/10] Title standard done...".colorize(:green)
  title2Data = []
  n = 0
  while n < titleData.length
    current = titleData[n]
    next_one = titleData[n+1]

    if next_one && next_one.match?(/\A-+\z/)
      title2Data << "<h2>#{current}</h2>"
      n += 2
    elsif next_one && next_one.match?(/\A=+\z/)
      title2Data << "<h1>#{current}</h1>"
      n += 2
    else
      title2Data << current
      n += 1
    end
  end

  puts title2Data.join("\n")
  puts "[2/10] Title alternate done...".colorize(:green)

  # end
  preFinalHTML = title2Data.join("\n")
  finalHTML =
  '<!DOCTYPE html>
  <html lang="en">
    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.8.0/styles/atom-one-dark.min.css">
      <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.8.0/highlight.min.js"></script>
      <link href="https://fonts.googleapis.com/css2?family=Source+Sans+3:ital,wght@0,200..900;1,200..900&display=swap" rel="stylesheet">
      <title>'+ File.basename(path, File.extname(path)) +'</title>
      <style>
        *{
          font-family: "Source Sans 3", sans-serif;
          font-optical-sizing: auto;
          font-weight: auto;
          font-style: normal;
        }
        body{
          background-color: #ffffff;
          color: #000000;
        }
        html{
          padding-left: 30px;
        }
      </style>
      <script>
        hljs.highlightAll();
      </script>
    </head>
    <body>
    ' + preFinalHTML + '
    </body>
  </html>'
  return finalHTML
end

def codeAnalyse(markdown)
    markdown.gsub(/```(\w+)?\n(.*?)```/m) do
      lang = $1 || ""
      code = $2
      "<pre><code class='language-#{lang}'>#{escape_html(code)}</code></pre>"
    end
end

def escape_html(text)
  text.gsub("&", "&amp;").gsub("<", "&lt;").gsub(">", "&gt;")
end

def titleAnalyse(line,lastLine)
  if line.match?(/\A\#{1,6}\s+/)
    level = line[/\A(\#{1,6})\s+/, 1]&.length
    line = line.sub(/\A\#{1,6}\s+/, "")
    return "<h" + level.to_s + ">" + line + "</h" + level.to_s + ">"
  end
  return line
end

main()
