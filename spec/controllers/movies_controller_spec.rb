require 'spec_helper'

describe MoviesController do #clase del controlador a probar

  describe 'samedir' do #metodo del controlador a probar

=begin  
    before :each do 
      @fake_movies = [mock('Movie'), mock('Movie')]
      @fake_movie = FactoryGirl.create(:movie, :id => "1", :title => "Star Wars", :director => "George Lucas") 
    end
=end

    it 'should call a model method in the Movie model to find movies whose director matches that of the current movie' do
      fake_movie = mock('Movie', :id => 1, :director => 'George Lucas')
      
      Movie.stub(:find).and_return(fake_movie)
      Movie.should_receive(:find_all_by_director).with('George Lucas')

      get :samedir, {:id => fake_movie.id}
    end
#    it 'should select the Samedir template for rendering'
#    it 'should meke the same director movies available to that template'
  end #describe

end #describe
