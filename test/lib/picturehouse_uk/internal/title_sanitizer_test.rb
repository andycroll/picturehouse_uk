require_relative '../../../test_helper'

describe PicturehouseUk::Internal::TitleSanitizer do
  let(:described_class) { PicturehouseUk::Internal::TitleSanitizer }

  describe '#sanitized' do
    subject { described_class.new(title).sanitized }

    describe 'with HTML &amp; in title' do
      let(:title) { 'Withnail &amp; I' }

      it 'removes dimension' do
        subject.must_equal('Withnail & I')
      end
    end

    describe 'with 2d in title' do
      let(:title) { 'Iron Man 3 2D' }

      it 'removes dimension' do
        subject.must_equal('Iron Man 3')
      end
    end

    describe 'with (2d) in title' do
      let(:title) { 'ParaNorman (2D)' }

      it 'removes dimension' do
        subject.must_equal('ParaNorman')
      end
    end

    describe 'with film release year' do
      let(:title) { 'Miracle on 34th Street (1947)' }

      it 'removes year' do
        subject.must_equal('Miracle on 34th Street')
      end
    end

    describe 'with 3d in title' do
      let(:title) { 'Iron Man 3 3d' }

      it 'removes dimension' do
        subject.must_equal('Iron Man 3')
      end
    end

    describe 'autism friendly' do
      let(:title) { 'Tarzan - Autism-Friendly Screening' }

      it 'removes screening type' do
        subject.must_equal('Tarzan')
      end
    end

    describe 'with NO CERT in title' do
      let(:title) { 'Iron Man 3 [NO CERT]' }

      it 'removes dimension' do
        subject.must_equal('Iron Man 3')
      end
    end

    describe 'with blank cert in title' do
      let(:title) { 'Iron Man 3 []' }

      it 'removes dimension' do
        subject.must_equal('Iron Man 3')
      end
    end

    describe 'with cert in title' do
      let(:title) { 'Beauty and the Beast 2D [U]' }

      it 'removes dimension' do
        subject.must_equal('Beauty and the Beast')
      end
    end

    describe 'with KIDS CLUB in title' do
      let(:title) { 'KIDS CLUB Escape from Planet Earth' }

      it 'removes KIDS CLUB' do
        subject.must_equal('Escape from Planet Earth')
      end
    end

    describe 'with DISCOVER TUE in title' do
      let(:title) { 'DISCOVER TUE All this Mayhem' }

      it 'remove rogue screening type' do
        subject.must_equal('All this Mayhem')
      end
    end

    describe 'with Discover Tuesday in title' do
      let(:title) { 'Discover Tuesday: Manakamana [U]' }

      it 'remove rogue screening type' do
        subject.must_equal('Manakamana')
      end
    end

    describe 'with Singalong' do
      let(:title) { 'Frozen Singalong [PG]' }

      it 'remove rogue screening type' do
        subject.must_equal('Frozen')
      end
    end

    describe 'with free screening' do
      let(:title) { 'FREE Screening - Withnail &amp; I' }

      it 'remove rogue screening type' do
        subject.must_equal('Withnail & I')
      end
    end

    describe 'with (Re) in title' do
      let(:title) { 'Beauty and the Beast 2D (Re) [U]' }

      it 'removes dimension' do
        subject.must_equal('Beauty and the Beast')
      end
    end

    describe 'with Q&A' do
      let(:title) { 'Hidden Colors 3: The Rules of Racism + Q&amp;A' }

      it 'removes suffix' do
        subject.must_equal('Hidden Colors 3: The Rules of Racism')
      end
    end

    describe 'with large Q+A' do
      let(:title) { 'Luna Plus Q&A with Director and Artist Dave McKean' }

      it 'removes suffix' do
        subject.must_equal('Luna')
      end
    end

    describe 'with panel discussion' do
      let(:title) { 'A Dangerous Game + Panel Discussion' }

      it 'removes suffix' do
        subject.must_equal('A Dangerous Game')
      end
    end

    describe 'cinemania film festival' do
      let(:title) { 'Cinemania: The Imposter' }

      it 'removes prefix' do
        subject.must_equal('The Imposter')
      end
    end

    describe '@ Komedia at the Little Thetre cinema' do
      let(:title) { 'Gone Girl @ Komedia [18]' }

      it 'removes suffix' do
        subject.must_equal('Gone Girl')
      end
    end

    describe '@ Komedia at the Little Thetre cinema' do
      let(:title) { 'Paddington@Komedia' }

      it 'removes suffix' do
        subject.must_equal('Paddington')
      end
    end

    describe 'imax' do
      let(:title) { 'Dinosaurs Alive! IMAX' }

      it 'removes suffix' do
        subject.must_equal('Dinosaurs Alive!')
      end
    end

    describe 're-issue' do
      let(:title) { 'Metropolis (Re-issue)' }

      it 'removes suffix' do
        subject.must_equal('Metropolis')
      end
    end

    describe 'with HOH Subtitled in the title' do
      let(:title) { "'71 *HOH Subtitled*" }

      it 'removes extra info' do
        subject.must_equal("'71")
      end
    end

    describe 'with Big Scream in the title' do
      let(:title) { 'Big Scream - Effie Gray' }

      it 'removes extra info' do
        subject.must_equal('Effie Gray')
      end
    end

    describe 'with kids club in the title' do
      let(:title) { "ParaNorman (2D) - Kids' Club" }

      it 'removes extra info' do
        subject.must_equal('ParaNorman')
      end
    end

    describe 'with reminiscence in the title' do
      let(:title) { "Rosemary's Baby - Reminiscence" }

      it 'removes extra info' do
        subject.must_equal("Rosemary's Baby")
      end
    end

    describe 'Bolshoi screening' do
      let(:title) { 'Bolshoi: Spartacus [NO CERT]' }

      it 'removes prefix' do
        subject.must_equal('Bolshoi: Spartacus')
      end
    end

    describe 'Bolshoi with captured' do
      let(:title) { 'Bolshoi: La Bayadere (Captured Live in 2012)' }

      it 'removes suffix' do
        subject.must_equal('Bolshoi: La Bayadere')
      end
    end

    describe 'Glyndebourne' do
      let(:title) do
        'Glyndebourne Tour 2014: The Cunning Little Vixen [CERT TBC]'
      end

      it 'removes certificate TBC' do
        subject.must_equal 'Glyndebourne Tour 2014: The Cunning Little Vixen'
      end
    end

    describe 'Met Opera screening' do
      let(:title) { 'Met. Opera: Macbeth [NO CERT]' }

      it 'removes prefix' do
        subject.must_equal('Met Opera: Macbeth')
      end
    end

    describe 'Met Opera screening v2' do
      let(:title) { 'Met Opera: Rusalka [AS LIVE: 12A]' }

      it 'removes prefix' do
        subject.must_equal('Met Opera: Rusalka')
      end
    end

    describe 'Met Opera screening v3' do
      let(:title) { 'Met Opera:Le Nozze di Figaro [AS LIVE:12A]' }

      it 'removes prefix' do
        subject.must_equal('Met Opera: Le Nozze di Figaro')
      end
    end

    describe 'NT Live screening' do
      let(:title) { 'National Theatre: Hamlet [PG]' }

      it 'removes prefix' do
        subject.must_equal('NT Live: Hamlet')
      end
    end

    describe 'ourscreen' do
      let(:title) { 'ourscreen: Northern Soul [15]' }

      it 'removes prefix' do
        subject.must_equal('Northern Soul')
      end
    end

    describe 're release' do
      let(:title) { 'To Kill A Mockingbird (Re) [PG]' }

      it 'removes rerelease notice' do
        subject.must_equal('To Kill A Mockingbird')
      end
    end

    describe 're release with year' do
      let(:title) { 'Withnail & I (re: 2014) [15]' }

      it 'removes rerelease notice' do
        subject.must_equal('Withnail & I')
      end
    end

    describe 'toddler time' do
      let(:title) { 'TODDLER TIME: Timmy Time Programme 15' }

      it 'removes rerelease notice' do
        subject.must_equal('Timmy Time Programme 15')
      end
    end

    describe 'Royal Opera House screening' do
      let(:title) { 'Royal Shakespeare Company: Richard II [NO CERT]' }

      it 'removes prefix' do
        subject.must_equal('Royal Shakespeare Company: Richard II')
      end
    end

    describe 'Royal Opera House encore screening' do
      let(:title) { 'ROH Encore: Swan Lake' }

      it 'removes prefix' do
        subject.must_equal('Royal Opera House: Swan Lake')
      end
    end

    describe 'parent and babies screening' do
      let(:title) { 'Paddington - Parents & Babies' }

      it 'removes suffix' do
        subject.must_equal('Paddington')
      end
    end

    describe 'subtitled screening' do
      let(:title) { 'Subtitled: The Hobbit: The Battle of the Five Armies' }

      it 'removes prefix' do
        subject.must_equal('The Hobbit: The Battle of the Five Armies')
      end
    end

    describe 'live' do
      let(:title) { 'English National Opera: Carmen (Live)' }

      it 'removes live suffix' do
        subject.must_equal('English National Opera: Carmen')
      end
    end

    describe 'remove [TBC] certificate' do
      let(:title) { 'The Living Room with Gavin Clark [TBC]' }

      it 'removes tbc cert' do
        subject.must_equal('The Living Room with Gavin Clark')
      end
    end

    describe 'remove [N/A] certificate' do
      let(:title) { 'Woman In Gold [N/A]' }

      it 'removes tbc cert' do
        subject.must_equal('Woman In Gold')
      end
    end

    describe 'remove (Theatre) designation' do
      let(:title) { 'Maxine Peake As Hamlet (Theatre)' }

      it 'removes tbc cert' do
        subject.must_equal('Maxine Peake As Hamlet')
      end
    end

    describe 'remove [R18] certificate' do
      let(:title) { "Dr Sketchy's Anti-Art School [R18]" }

      it 'removes tbc cert' do
        subject.must_equal("Dr Sketchy's Anti-Art School")
      end
    end

    describe 'Bolshoi' do
      let(:title) { 'Spartacus (Bolshoi Ballet)' }

      it 'reorders the title' do
        subject.must_equal('Bolshoi Ballet: Spartacus')
      end
    end
  end
end
