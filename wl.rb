#!/usr/bin/ruby
require 'optparse'
require 'shellwords'
require 'open3'

options = {}
OptionParser.new do |opts|
  #Defaults
  options[:paper_notes_file] = "/home/will/Papers/notes.txt"
  options[:paper_dir] = "/home/will/Papers/"
  options[:notes_dir]   = "/home/will/Notes/"
  options[:thorough] = false
  
  opts.banner = "wl: Will's Libary of Will. http://github.com/willpearse/wl\nUsage: wl.rb [options]"
  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end

  opts.on("-p NAME", "--papers NAME", "Search papers (and their notes) for NAME") {|x| options[:scientist] = x}
  opts.on("-o INT", "--openpdf INT", "Open INT PDF") {|x| options[:open_pdf] = x.to_i}
  opts.on("-e NAME", "--email NAME", "Have you emailed NAME?") {|x| options[:met] = x}
  opts.on("-n NAME", "--notes", "Search notes for NAME") {|x| options[:notes] = x}
  opts.on("--thorough", "Perform thorough searches") {options[:thorough] = true}
  
  opts.on("-")
end.parse!

#Handle defaults (...somewhat hackily as an add-on...)
ARGV.reverse!
scientist = ARGV.pop
if scientist
  options[:scientist] = scientist
  open_pdf = ARGV.pop
  if open_pdf then options[:open_pdf] = open_pdf.to_i end
end

#Search for papers
if options[:scientist]
  #PDFs
  files = Dir.glob(options[:paper_dir]+"**/*")
  results = []
  files.each do |file|    
    if file.downcase.include? options[:scientist].downcase then results.push(file) end
  end
  puts "#{results.length} papers found:"
  if options[:open_pdf]
    Open3.capture2e "evince #{Shellwords.escape(results[options[:open_pdf]-1])}"
  end
  results.each_with_index do |res, i|
    res = res.sub(options[:paper_dir], "")
    if res.length > 65 then res = res[0..75] + "..." end
    puts " #{i+1} #{res}"
  end
  
  #Notes
  puts ""
  results = []; header = ""; next_time = false
  File.open options[:paper_notes_file] do |handle|
    handle.each_line do |line|
      if next_time
        if line.length > 75 then line = line[0..71] + "..." end
        results.push "    #{line}"
        next_time = false
      else
        if line.downcase.include? options[:scientist]
          if line[0] == "\t"
            results.push header
            if line.length > 75 then line = line[0..71] + "..." end
            results.push "    #{line}"
          else
            header = line
            if line.downcase.include? options[:scientist]
              if line.length > 75 then line = line[0..73] + "..." end
              results.push "  #{line}"
            end
            next_time = true
          end
        end
      end
    end
  end  
  puts "#{results.length / 2} PDF notes found:"
  results.each do |line|
    puts line
  end
end

#Search known people
if options[:met]
  File.open options[:email_file] do |handle|
    handle.each_line do |line|
      if line.include? options[:met]
        puts "  - potentially email contact"
        break
      end
    end
  end
end

if options[:notes]
  files = Dir.glob(options[:notes_dir]+"**/*")
  results = []
  extras = 0
  files.each do |file|
    if file.downcase.include? options[:notes].downcase then results.push(file) end
    if options[:thorough]
      File.open file do |handle|
        handle.each_line do |line|
          if line.downcase.include? options[:notes].downcase
            results.push(file)
            if line.length > 75 then line = res[0..71] + "..." end
            results.push("  "+line)
            extras += 1
            break
          end
        end
      end
    end
  end
  puts "#{results.length - extras} notes found:"
  results.each do |res|
    res = res.sub(options[:paper_dir], "")
    if res.length > 75 then res = res[0..75] + "..." end
    puts "  #{res}"
  end
end
