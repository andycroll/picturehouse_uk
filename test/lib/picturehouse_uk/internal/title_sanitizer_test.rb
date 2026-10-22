require_relative '../../../test_helper'

class PicturehouseUkInternalTitleSanitizerTest < Minitest::Test
  def test_sanitized_with_html_amp_in_title
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Withnail &amp; I')
    assert_equal 'Withnail & I', sanitizer.sanitized
  end

  def test_sanitized_with_2d_in_title
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Iron Man 3 2D')
    assert_equal 'Iron Man 3', sanitizer.sanitized
  end

  def test_sanitized_with_2d_in_parentheses_in_title
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('ParaNorman (2D)')
    assert_equal 'ParaNorman', sanitizer.sanitized
  end

  def test_sanitized_with_film_release_year
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Miracle on 34th Street (1947)')
    assert_equal 'Miracle on 34th Street', sanitizer.sanitized
  end

  def test_sanitized_with_3d_in_title
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Iron Man 3 3d')
    assert_equal 'Iron Man 3', sanitizer.sanitized
  end

  def test_sanitized_with_autism_friendly
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Tarzan - Autism-Friendly Screening')
    assert_equal 'Tarzan', sanitizer.sanitized
  end

  def test_sanitized_with_no_cert_in_title
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Iron Man 3 [NO CERT]')
    assert_equal 'Iron Man 3', sanitizer.sanitized
  end

  def test_sanitized_with_blank_cert_in_title
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Iron Man 3 []')
    assert_equal 'Iron Man 3', sanitizer.sanitized
  end

  def test_sanitized_with_cert_in_title
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Beauty and the Beast 2D [U]')
    assert_equal 'Beauty and the Beast', sanitizer.sanitized
  end

  def test_sanitized_with_kids_club_in_title
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('KIDS CLUB Escape from Planet Earth')
    assert_equal 'Escape from Planet Earth', sanitizer.sanitized
  end

  def test_sanitized_with_discover_tue_in_title
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('DISCOVER TUE All this Mayhem')
    assert_equal 'All this Mayhem', sanitizer.sanitized
  end

  def test_sanitized_with_discover_tuesday_in_title
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Discover Tuesday: Manakamana [U]')
    assert_equal 'Manakamana', sanitizer.sanitized
  end

  def test_sanitized_with_singalong
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Frozen Singalong [PG]')
    assert_equal 'Frozen', sanitizer.sanitized
  end

  def test_sanitized_with_free_screening
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('FREE Screening - Withnail &amp; I')
    assert_equal 'Withnail & I', sanitizer.sanitized
  end

  def test_sanitized_with_re_in_title
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Beauty and the Beast 2D (Re) [U]')
    assert_equal 'Beauty and the Beast', sanitizer.sanitized
  end

  def test_sanitized_with_q_and_a
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Hidden Colors 3: The Rules of Racism + Q&amp;A')
    assert_equal 'Hidden Colors 3: The Rules of Racism', sanitizer.sanitized
  end

  def test_sanitized_with_large_q_and_a
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Luna Plus Q&A with Director and Artist Dave McKean')
    assert_equal 'Luna', sanitizer.sanitized
  end

  def test_sanitized_with_panel_discussion
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('A Dangerous Game + Panel Discussion')
    assert_equal 'A Dangerous Game', sanitizer.sanitized
  end

  def test_sanitized_with_cinemania_film_festival
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Cinemania: The Imposter')
    assert_equal 'The Imposter', sanitizer.sanitized
  end

  def test_sanitized_with_at_komedia_with_spaces
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Gone Girl @ Komedia [18]')
    assert_equal 'Gone Girl', sanitizer.sanitized
  end

  def test_sanitized_with_at_komedia_no_spaces
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Paddington@Komedia')
    assert_equal 'Paddington', sanitizer.sanitized
  end

  def test_sanitized_with_imax
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Dinosaurs Alive! IMAX')
    assert_equal 'Dinosaurs Alive!', sanitizer.sanitized
  end

  def test_sanitized_with_re_issue
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Metropolis (Re-issue)')
    assert_equal 'Metropolis', sanitizer.sanitized
  end

  def test_sanitized_with_hoh_subtitled
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new("'71 *HOH Subtitled*")
    assert_equal "'71", sanitizer.sanitized
  end

  def test_sanitized_with_big_scream
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Big Scream - Effie Gray')
    assert_equal 'Effie Gray', sanitizer.sanitized
  end

  def test_sanitized_with_kids_club
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new("ParaNorman (2D) - Kids' Club")
    assert_equal 'ParaNorman', sanitizer.sanitized
  end

  def test_sanitized_with_reminiscence
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new("Rosemary's Baby - Reminiscence")
    assert_equal "Rosemary's Baby", sanitizer.sanitized
  end

  def test_sanitized_with_bolshoi_screening
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Bolshoi: Spartacus [NO CERT]')
    assert_equal 'Bolshoi: Spartacus', sanitizer.sanitized
  end

  def test_sanitized_with_bolshoi_with_captured
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Bolshoi: La Bayadere (Captured Live in 2012)')
    assert_equal 'Bolshoi: La Bayadere', sanitizer.sanitized
  end

  def test_sanitized_with_glyndebourne
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Glyndebourne Tour 2014: The Cunning Little Vixen [CERT TBC]')
    assert_equal 'Glyndebourne Tour 2014: The Cunning Little Vixen', sanitizer.sanitized
  end

  def test_sanitized_with_met_opera_screening
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Met. Opera: Macbeth [NO CERT]')
    assert_equal 'Met Opera: Macbeth', sanitizer.sanitized
  end

  def test_sanitized_with_met_opera_screening_v2
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Met Opera: Rusalka [AS LIVE: 12A]')
    assert_equal 'Met Opera: Rusalka', sanitizer.sanitized
  end

  def test_sanitized_with_met_opera_screening_v3
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Met Opera:Le Nozze di Figaro [AS LIVE:12A]')
    assert_equal 'Met Opera: Le Nozze di Figaro', sanitizer.sanitized
  end

  def test_sanitized_with_nt_live_screening
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('National Theatre: Hamlet [PG]')
    assert_equal 'NT Live: Hamlet', sanitizer.sanitized
  end

  def test_sanitized_with_ourscreen
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('ourscreen: Northern Soul [15]')
    assert_equal 'Northern Soul', sanitizer.sanitized
  end

  def test_sanitized_with_re_release
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('To Kill A Mockingbird (Re) [PG]')
    assert_equal 'To Kill A Mockingbird', sanitizer.sanitized
  end

  def test_sanitized_with_re_release_with_year
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Withnail & I (re: 2014) [15]')
    assert_equal 'Withnail & I', sanitizer.sanitized
  end

  def test_sanitized_with_toddler_time
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('TODDLER TIME: Timmy Time Programme 15')
    assert_equal 'Timmy Time Programme 15', sanitizer.sanitized
  end

  def test_sanitized_with_royal_opera_house_screening
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Royal Shakespeare Company: Richard II [NO CERT]')
    assert_equal 'Royal Shakespeare Company: Richard II', sanitizer.sanitized
  end

  def test_sanitized_with_royal_opera_house_encore_screening
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('ROH Encore: Swan Lake')
    assert_equal 'Royal Opera House: Swan Lake', sanitizer.sanitized
  end

  def test_sanitized_with_parent_and_babies_screening
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Paddington - Parents & Babies')
    assert_equal 'Paddington', sanitizer.sanitized
  end

  def test_sanitized_with_subtitled_screening
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Subtitled: The Hobbit: The Battle of the Five Armies')
    assert_equal 'The Hobbit: The Battle of the Five Armies', sanitizer.sanitized
  end

  def test_sanitized_with_live
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('English National Opera: Carmen (Live)')
    assert_equal 'English National Opera: Carmen', sanitizer.sanitized
  end

  def test_sanitized_removes_tbc_certificate
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('The Living Room with Gavin Clark [TBC]')
    assert_equal 'The Living Room with Gavin Clark', sanitizer.sanitized
  end

  def test_sanitized_removes_na_certificate
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Woman In Gold [N/A]')
    assert_equal 'Woman In Gold', sanitizer.sanitized
  end

  def test_sanitized_removes_theatre_designation
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Maxine Peake As Hamlet (Theatre)')
    assert_equal 'Maxine Peake As Hamlet', sanitizer.sanitized
  end

  def test_sanitized_removes_r18_certificate
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new("Dr Sketchy's Anti-Art School [R18]")
    assert_equal "Dr Sketchy's Anti-Art School", sanitizer.sanitized
  end

  def test_sanitized_with_bolshoi_reorders_title
    sanitizer = PicturehouseUk::Internal::TitleSanitizer.new('Spartacus (Bolshoi Ballet)')
    assert_equal 'Bolshoi Ballet: Spartacus', sanitizer.sanitized
  end
end
