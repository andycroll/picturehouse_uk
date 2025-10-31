require 'json'

# Fake API client for reading JSON fixtures from disk
class FakeApi
  def get_movies(cinema_id, _date = 'show_all_dates')
    JSON.parse(read_file("../../fixtures/#{cinema_id}/get_movies.json"))
  rescue Errno::ENOENT
    { 'response' => 'error', 'movies' => [] }
  end

  private

  def read_file(filepath)
    File.read(File.expand_path(filepath, __FILE__))
  end
end
