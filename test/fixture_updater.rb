require File.expand_path('../../lib/picturehouse_uk.rb', __FILE__)

def fixture(name)
  File.expand_path("../fixtures/#{name}.html", __FILE__)
end

File.open(fixture('home'), 'w') do |file|
  puts '* Homepage'
  file.write PicturehouseUk::Internal::Website.new.home
end

# DUKE OF YORKS

File.open(fixture('cinema/Duke_Of_Yorks'), 'w') do |file|
  puts '* Duke of Yorks'
  file.write PicturehouseUk::Internal::Website.new.cinema('Duke_Of_Yorks')
end

File.open(fixture('info/Duke_Of_Yorks'), 'w') do |file|
  puts '* Duke of Yorks Information'
  file.write PicturehouseUk::Internal::Website.new.info('Duke_Of_Yorks')
end

# KOMEDIA

File.open(fixture('cinema/Dukes_At_Komedia'), 'w') do |file|
  puts '* Dukes at Komedia'
  file.write PicturehouseUk::Internal::Website.new.cinema('Dukes_At_Komedia')
end

File.open(fixture('info/Dukes_At_Komedia'), 'w') do |file|
  puts '* Dukes at Komedia Information'
  file.write PicturehouseUk::Internal::Website.new.info('Dukes_At_Komedia')
end

# PHEONIX OXFORD

File.open(fixture('cinema/Phoenix_Picturehouse'), 'w') do |file|
  puts '* Pheonix Oxford'
  file.write PicturehouseUk::Internal::Website.new.cinema('Phoenix_Picturehouse')
end

File.open(fixture('info/Phoenix_Picturehouse'), 'w') do |file|
  puts '* Pheonix Oxford Information'
  file.write PicturehouseUk::Internal::Website.new.info('Phoenix_Picturehouse')
end
