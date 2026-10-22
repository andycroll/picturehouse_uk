require_relative '../../test_helper'

class PicturehouseUk::PerformanceTest < Minitest::Test
  DATE = Date.new(2026, 10, 24)

  def setup
    @api_response = FakeApiResponse.new
  end

  def test_at_returns_performances
    performances = performances_at(19)

    assert(performances.all? { |p| p.instance_of?(PicturehouseUk::Performance) })
    assert_equal 5, performances.count
  end

  def test_at_accepts_string_id
    assert_equal 5, performances_at('019').count
  end

  def test_at_sets_cinema_details
    performances = performances_at(19)

    assert_equal ['019'], performances.map(&:cinema_id).uniq
    assert_equal ["Duke's at Komedia"], performances.map(&:cinema_name).uniq
  end

  def test_at_parses_first_performance
    performance = performances_at(19).first

    assert_equal 'The Example Film', performance.film_name
    assert_equal Time.utc(2026, 10, 24, 9, 30), performance.starting_at
    assert_equal '2d', performance.dimension
    assert_equal %w(audio_described), performance.variant
    assert_equal 'https://web.picturehouses.com/order/showtimes/019-1001/seats',
                 performance.booking_url
  end

  def test_at_parses_3d_silver_screen
    performance = performances_at(19)[1]

    assert_equal '3d', performance.dimension
    assert_equal %w(senior), performance.variant
  end

  def test_at_moves_film_year_from_title
    performance = performances_at(19)[2]

    assert_equal 'Imaginary Picture', performance.film_name
    assert_equal 1996, performance.film_year
    assert_equal %w(q&a subtitled), performance.variant
    assert performance.subtitled?
  end

  def test_at_strips_q_and_a_add_on
    performance = performances_at(19)[3]

    assert_equal 'Pretend Pups', performance.film_name
    assert_equal %w(baby kids), performance.variant
  end

  def test_at_moves_festival_from_title
    performance = performances_at(19)[4]

    assert_equal 'Made Up Matinee', performance.film_name
    assert_equal Cinebase::Festival.new(name: 'CFF', year: 2026), performance.festival
    assert_equal %w(arts subtitled), performance.variant
  end

  def test_at_keeps_after_midnight_on_next_utc_day
    assert_equal Time.utc(2026, 10, 24, 23, 15), performances_at(19).last.starting_at
  end

  def test_at_requests_each_date_in_range
    to = DATE + 2

    with_fake_api { PicturehouseUk::Performance.at(19, from: DATE, to: to) }

    assert_equal (DATE..to).to_a, @api_response.requested_dates
  end

  def test_at_rejects_range_ending_before_start
    assert_raises(ArgumentError) do
      PicturehouseUk::Performance.at(19, from: DATE, to: DATE - 1)
    end
  end

  def test_new_sets_defaults
    performance = PicturehouseUk::Performance.new(
      film_name: 'Carol', cinema_id: '019', cinema_name: "Duke's at Komedia",
      starting_at: Time.utc(2013, 9, 12, 11, 0)
    )

    assert_nil performance.booking_url
    assert_equal '2d', performance.dimension
    assert_nil performance.festival
    assert_nil performance.film_year
    refute performance.subtitled?
    assert_equal [], performance.variant
  end

  private

  def performances_at(cinema_id)
    with_fake_api { PicturehouseUk::Performance.at(cinema_id, from: DATE, to: DATE) }
  end

  def with_fake_api(&block)
    PicturehouseUk::Internal::ApiResponse.stub(:new, @api_response, &block)
  end
end
