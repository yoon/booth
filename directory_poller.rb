require 'fileutils'
require 'spinner'

def poll(max=8)
  animation = Spinner.new
  processed = []
  while processed.size < max do
    sleep 5
    list = Dir.entries(File.join(File.dirname(__FILE__), '/files')) - [".", ".."]
    todo = list - processed
    if todo.size&3 == 0 && !todo.empty?
      process(todo[0,4])
      processed += todo[0,4]
    end
  end
  animation.stop
end

def process(files)
  puts "Processing #{files.inspect}"
  files.each do |file|
    FileUtils.move(File.join(File.dirname(__FILE__), '/files/', file), FileUtils.move(File.join(File.dirname(__FILE__), '/processed/'))
  end
end

poll