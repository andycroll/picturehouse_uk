require_relative '../../../test_helper'

class PicturehouseUk::Internal::ApiResponseTest < Minitest::Test
  include ApiFixturesHelper

  BASE_URL = 'https://digital-api.picturehouses.com/ocapi/v1'.freeze

  def setup
    PicturehouseUk.token = 'guest-jwt'
  end

  def teardown
    PicturehouseUk.token = nil
    super
  end

  def test_sites_sends_token_without_region
    stub_request(:get, "#{BASE_URL}/sites")
      .with { |request| request.headers['Authorization'] == 'Bearer guest-jwt' && !request.headers.key?('Connect-Region-Code') }
      .to_return(status: 200, body: sites_json)

    assert_equal %w(002 013 019), api.sites.map { |site| site['id'] }
  end

  def test_showtimes
    stub_request(:get, "#{BASE_URL}/showtimes/by-business-date/2026-10-24")
      .with(query: { 'siteIds' => '019' })
      .to_return(status: 200, body: showtimes_json('019'))

    showtimes = api.showtimes('019', Date.new(2026, 10, 24))

    assert_equal %w(businessDate relatedData showtimes), showtimes.keys.sort
  end

  def test_missing_token_raises_before_request
    PicturehouseUk.token = nil

    assert_raises(PicturehouseUk::AuthenticationError) { api.sites }
  end

  def test_rejected_token_raises
    stub_request(:get, "#{BASE_URL}/sites").to_return(status: 401)

    assert_raises(PicturehouseUk::AuthenticationError) { api.sites }
  end

  def test_reuses_one_client_while_the_token_holds
    stub_request(:get, "#{BASE_URL}/sites").to_return(status: 200, body: sites_json)
    shared = api

    assert_equal 1, count_clients { 3.times { shared.sites } }
  end

  def test_builds_a_new_client_for_a_new_token
    stub_request(:get, "#{BASE_URL}/sites").to_return(status: 200, body: sites_json)
    shared = api

    clients = count_clients do
      shared.sites
      PicturehouseUk.token = 'renewed-jwt'
      shared.sites
    end

    assert_equal 2, clients
  end

  private

  def count_clients
    clients = 0
    original = Cinebase::Vista::Client.method(:new)
    counting = ->(**options) { clients += 1; original.call(**options) }
    Cinebase::Vista::Client.stub(:new, counting) { yield }
    clients
  end

  def api
    PicturehouseUk::Internal::ApiResponse.new
  end
end
