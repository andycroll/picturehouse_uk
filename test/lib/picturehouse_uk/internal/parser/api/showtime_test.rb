require_relative '../../../../../test_helper'

class PicturehouseUk::Internal::Parser::Api::ShowtimeTest < Minitest::Test
  FILMS = {
    'HO1' => { 'title' => { 'text' => 'Sense and Sensibility (2026)' } },
    'HO2' => { 'title' => { 'text' => 'CFF: Rocket Girl' } }
  }.freeze

  ATTRIBUTES = {
    '1' => { 'shortName' => { 'text' => 'Kids\' Club' }, 'name' => { 'text' => 'Kids\' Club' } },
    '2' => { 'shortName' => { 'text' => 'Q+A' }, 'name' => { 'text' => '+ Q&A ' } },
    '3' => { 'shortName' => { 'text' => 'Relaxed' }, 'name' => { 'text' => 'Relaxed' } },
    '4' => { 'shortName' => { 'text' => 'Laser' }, 'name' => { 'text' => 'Laser Projection' } }
  }.freeze

  def test_to_hash
    expected = {
      booking_url: 'https://web.picturehouses.com/order/showtimes/019-1/seats',
      dimension: '2d',
      festival: nil,
      film_name: 'Sense and Sensibility',
      film_year: 2026,
      starting_at: Time.utc(2026, 10, 24, 17, 30),
      variant: []
    }

    assert_equal expected, parse
  end

  def test_3d_glasses
    assert_equal '3d', parse(requires3d: true)[:dimension]
  end

  def test_maps_attribute_names_to_variants
    assert_equal %w(kids q&a relaxed), parse(attribute_ids: %w(1 2 3 4))[:variant]
  end

  def test_festival
    showtime = parse(film_id: 'HO2')

    assert_equal Cinebase::Festival.new(name: 'CFF', year: 2026), showtime[:festival]
    assert_equal 'Rocket Girl', showtime[:film_name]
  end

  private

  def parse(attribute_ids: [], requires3d: false, film_id: 'HO1')
    data = {
      'id' => '019-1',
      'filmId' => film_id,
      'schedule' => { 'startsAt' => '2026-10-24T18:30:00+01:00' },
      'attributeIds' => attribute_ids,
      'requires3dGlasses' => requires3d
    }
    PicturehouseUk::Internal::Parser::Api::Showtime.new(
      data, films: FILMS, attributes: ATTRIBUTES
    ).to_hash
  end
end
