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
  file.write PicturehouseUk::Internal::Website.new.cinema('Duke_of_Yorks')
end

File.open(fixture('contact_us/Duke_Of_Yorks'), 'w') do |file|
  puts '* Duke of Yorks Information'
  file.write PicturehouseUk::Internal::Website.new.contact_us('Duke_of_Yorks')
end

# KOMEDIA

File.open(fixture('contact_us/Dukes_At_Komedia'), 'w') do |file|
  puts '* Dukes at Komedia Information'
  file.write PicturehouseUk::Internal::Website.new.contact_us('Dukes_At_Komedia')
end
