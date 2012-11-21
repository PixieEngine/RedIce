task :default => [:build]

task :build do
  main_file = "src/main.coffee"
  src_files = (Dir["src/*.coffee"] - [main_file]) + [main_file]

  sh "mkdir -p build"
  sh "coffee", "-bcj", "build/src.js", *src_files
  sh "cat build/app.js lib/*.js build/src.js > game.js"
end
