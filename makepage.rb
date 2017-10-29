#!/usr/bin/ruby

require 'fileutils'
MAX_PHOTOS = 9

# potentially get photos from a  specified directory
input_photos_dir = 'input-photos'
if ARGV.length > 0
  input_photos_dir = ARGV[0]
end

puts "Reading images from #{input_photos_dir}"

# get a list of the photos to use
photos = Dir.glob("#{input_photos_dir}/*.jpg", File::FNM_CASEFOLD)
# randomise photo input order
photos.shuffle!

pages = Dir.entries('pages')
new_page = "pages/#{pages.length - 1}"

if File.exist?(new_page)
  abort("Error: #{new_page} directory already exists!")
end

# make a directory for the page, and include all the templates
Dir.mkdir new_page
FileUtils.cp_r Dir.glob('templates/*.svg'), new_page

counter = 0
while counter < MAX_PHOTOS && rand = photos.pop
  puts "Using random image: #{rand}"
  if File.file? rand
    counter += 1
    FileUtils.cp rand, "#{new_page}/photo#{counter}.jpg"
  else
    puts "  Skipping, isn't a file!"
  end
end

# generate png exports for ease of review
Dir.glob("#{new_page}/*.svg").each do |x|
  system "inkscape #{x} -e #{x}.png"
end

