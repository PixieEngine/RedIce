task :default => [:build]

task :build do
  main_file = "src/main.coffee"
  src_files = (Dir["src/*.coffee"] - [main_file]) + [main_file]

  sh "mkdir -p build"
  sh "coffee", "-bcj", "build/src.js", *src_files
  sh "cat build/app.js build/data.js lib/*.js build/src.js > game.js"
end

task :build_data do
  require 'json'

  sh "mkdir -p build"

  data_files = Dir["data/*.json"]

  data = {}
  data_files.each do |filename|
    name = File.basename(filename, ".json")
    data[name] = JSON.parse(File.read(filename))
  end

  File.open "build/data.js", "w" do |f|
    f << "Data = "
    f << JSON.dump(data)
  end
end
