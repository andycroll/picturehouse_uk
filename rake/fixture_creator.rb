# Create fitures from the live website
class FixtureCreator
  def cinema(cinema_id)
    %i(cinema information).each do |action|
      write_fixture_for_cinema(cinema_id, action)
    end
  end

  def home
    write_fixture(:home)
  end

  private

  def fixture(name)
    File.expand_path("#{fixture_path}/#{name}.html", __FILE__)
  end

  def fixture_path
    '../../test/fixtures'
  end

  def log(message)
    puts "Create API fixture: #{message}"
  end

  def write_fixture_for_cinema(cinema_id, kind)
    FileUtils.mkdir_p File.expand_path("#{fixture_path}/#{cinema_id}", __FILE__)
    text = "#{cinema_id}/#{kind}"
    File.open(fixture(text), 'w+') do |file|
      log(text)
      file.write PicturehouseUk::Internal::Website.new.send(kind, cinema_id)
    end
  end

  def write_fixture(kind)
    File.open(fixture(kind), 'w+') do |file|
      log(kind)
      file.write PicturehouseUk::Internal::Website.new.send(kind.to_sym)
    end
  end
end
