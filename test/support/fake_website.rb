# Fake website for reading fixtures from disk
class FakeWebsite
  def home
    read_file('../../fixtures/home.html')
  end

  def cinema(cinema_id)
    read_file("../../fixtures/#{cinema_id}/cinema.html")
  end

  def info(cinema_id)
    read_file("../../fixtures/#{cinema_id}/info.html")
  end

  def whats_on(cinema_id)
    read_file("../../fixtures/#{cinema_id}/whats_on.html")
  end

  private

  def read_file(filepath)
    File.read(File.expand_path(filepath, __FILE__))
  end
end
