require_relative '../../../test_helper'
require 'base64'
require 'tmpdir'

class PicturehouseUk::Internal::GuestTokenTest < Minitest::Test
  def setup
    @directory = Dir.mktmpdir('picturehouse-guest-token')
  end

  def teardown
    FileUtils.remove_entry(@directory)
    PicturehouseUk.token = nil
  end

  def test_fetch_returns_token_from_200_or_404_page
    token = token_expiring_at(Time.now + 3600)

    %w(200 404).each do |status|
      assert_equal token, guest_token(fake_curl("#{page_with(token)}\n#{status}")).fetch
    end
  end

  def test_fetch_rejects_expired_token
    curl = fake_curl("#{page_with(token_expiring_at(Time.now - 60))}\n200")

    assert_raises(PicturehouseUk::AuthenticationError) { guest_token(curl).fetch }
  end

  def test_fetch_rejects_page_without_page_data
    curl = fake_curl("<html></html>\n200")

    assert_raises(PicturehouseUk::AuthenticationError) { guest_token(curl).fetch }
  end

  def test_fetch_rejects_blocked_page
    curl = fake_curl("#{page_with(token_expiring_at(Time.now + 3600))}\n403")

    assert_raises(PicturehouseUk::AuthenticationError) { guest_token(curl).fetch }
  end

  def test_acquire_token_sets_token
    token = token_expiring_at(Time.now + 3600)

    PicturehouseUk.acquire_token!(curl: fake_curl("#{page_with(token)}\n200"))

    assert_equal token, PicturehouseUk.token
  end

  private

  def guest_token(curl)
    PicturehouseUk::Internal::GuestToken.new(curl: curl)
  end

  def token_expiring_at(time)
    payload = Base64.urlsafe_encode64(JSON.generate('exp' => time.to_i), padding: false)
    "header.#{payload}.signature"
  end

  def page_with(token)
    data = { 'props' => { 'pageProps' => { 'environment' => { 'gasToken' => token } } } }
    %(<script id="__NEXT_DATA__" type="application/json">#{JSON.generate(data)}</script>)
  end

  def fake_curl(output)
    path = File.join(@directory, 'curl-impersonate')
    File.write(path, "#!#{RbConfig.ruby}\nSTDOUT.write(#{output.dump})\n")
    File.chmod(0o755, path)
    path
  end
end
