require 'spec_helper'

describe MoviesController do
  describe "index" do
    it "should call model method to get movies list" do
      Movie.should_receive(:find_all_by_rating)
      get :index
    end
    it "populates a list of movies" do
      movie = stub_model(Movie, id: 1, director: 'Director Name')
      movie2 = stub_model(Movie, id: 2, director: 'Director Name 2')
      fake_list = [movie, movie2]
      Movie.stub(:find_all_by_rating).and_return(fake_list)
      get :index
      assigns(:movies).should eq(fake_list)
    end
    it "renders the :index view" do
      Movie.stub(:find_all_by_rating)
      get :index
      #movie.should
      response.should render_template('index')
    end
    it "should assign @all_ratings" do
      fake_list = [1,2,3]
      Movie.should_receive(:all_ratings).and_return(fake_list)
      Movie.stub(:find_all_by_rating)
      get :index
      assigns(:all_ratings).should eq(fake_list)
    end
    it "should assign @selected_ratings" do
      fake_list = ['1','2','3']
      Movie.stub(:all_ratings)
      Movie.stub(:find_all_by_rating)
      get :index, ratings: fake_list
      assigns(:selected_ratings).should eq(fake_list)
    end
    it "should assign @title_header" do
      fake_list = ['1','2','3']
      sort_by = 'title'
      Movie.stub(:all_ratings).and_return(fake_list)
      Movie.stub(:find_all_by_rating)
      get :index, sort: sort_by
      assigns(:title_header).should eq('hilite')
      assigns(:date_header).should eq(nil)
    end
    it "should assign @date_header" do
      fake_list = ['1','2','3']
      sort_by = 'release_date'
      Movie.stub(:all_ratings).and_return(fake_list)
      Movie.stub(:find_all_by_rating)
      get :index, sort: sort_by
      assigns(:title_header).should eq(nil)
      assigns(:date_header).should eq('hilite')
    end
  end

  describe "similar" do
    #fixtures :'movie.director'
    it "should call the model method that gets movie by id" do
      movie = stub_model(Movie, id: 1, director: 'Director Name')
      Movie.should_receive(:find).with('1').and_return(movie)
      Movie.stub(:find_all_by_director)
      #movie.should
      get :similar, id: 1
    end
    it "should call the model method that performs search movies by director of requested movie" do
      movie = stub_model(Movie, id: 1, director: 'Director Name')
      Movie.stub(:find).and_return(movie)
      Movie.should_receive(:find_all_by_director).with(movie.director)
      get :similar, id: 1
    end
    #it "populates a list of movies similar to movie :id"
    it "renders the :similar view when movies are found" do
      movie = stub_model(Movie, id: 1, director: 'Director Name')
      Movie.stub(:find).and_return(movie)
      Movie.stub(:find_all_by_director)
      get :similar, id: 1
      #movie.should
      response.should render_template('similar')
    end
    it "redirects to home page when movies not found" do
      movie = stub_model(Movie, id: 1, director: nil)
      Movie.stub(:find).and_return(movie)
      Movie.stub(:find_all_by_director)
      get :similar, id: 1
      #movie.should
      response.should redirect_to('/')
    end
  end

  describe "show" do
    it "should call Movie.find" do
      movie = stub_model(Movie, id: 1, director: nil)
      Movie.should_receive(:find).with('1').and_return(movie)
      get :show, id: 1
    end
    it "assigns the requested movie to @movie" do
      movie = stub_model(Movie, id: 1, director: nil)
      Movie.stub(:find).and_return(movie)
      get :show, id: 1
      assigns(:movie).should eq(movie)
    end
    it "renders the :show template" do
      Movie.stub(:find)
      get :show, id: 1
      response.should render_template('show')
    end
  end

  describe "new" do
    it "renders the :new template" do
      get :new
      response.should render_template('new')
    end
  end

  describe "create" do
    it "saves the new movie in the database" do
      Movie.should_receive(:create!).and_return(stub_model(Movie))
      post :create
    end
    it "redirects to the home page" do
      Movie.stub(:create!).and_return(stub_model(Movie))
      post :create
      response.should redirect_to movies_path
    end
  end

  describe "edit" do
    it "should call Movie.find" do
      movie = stub_model(Movie, id: 1, director: nil)
      Movie.should_receive(:find).with('1').and_return(movie)
      get :edit, id: 1
    end
    it "assigns the requested movie to @movie" do
      movie = stub_model(Movie, id: 1, director: nil)
      Movie.stub(:find).and_return(movie)
      get :edit, id: 1
      assigns(:movie).should eq(movie)
    end
    it "renders the :edit template" do
      Movie.stub(:find)
      get :edit, id: 1
      response.should render_template('edit')
    end
  end

  describe "update" do
    it "should call Movie.find" do
      movie = stub_model(Movie, id: 1, director: nil)
      Movie.should_receive(:find).with('1').and_return(movie)
      movie.stub(:update_attributes!)
      post :update, id: 1
    end
    it "should call Movie.update_attributes!" do
      movie = stub_model(Movie, id: 1, director: nil)
      Movie.stub(:find).with('1').and_return(movie)
      movie.should_receive(:update_attributes!)
      post :update, id: 1
    end
    it "assigns the requested movie to @movie" do
      movie = stub_model(Movie, id: 1, director: nil)
      Movie.stub(:find).and_return(movie)
      movie.stub(:update_attributes!)
      post :update, id: 1
      assigns(:movie).should eq(movie)
    end
    it "redirects to movies page" do
      movie = stub_model(Movie, id: 1, director: nil)
      Movie.stub(:find).and_return(movie)
      movie.stub(:update_attributes!)
      post :update, id: 1
      response.should redirect_to movie_path(movie)
    end
  end

  describe "destroy" do
    it "should call Movie.find" do
      movie = stub_model(Movie, id: 1, director: nil)
      Movie.should_receive(:find).with('1').and_return(movie)
      movie.stub(:destroy)
      post :destroy, id: 1
    end
    it "should call Movie.destroy" do
      movie = stub_model(Movie, id: 1, director: nil)
      Movie.stub(:find).with('1').and_return(movie)
      movie.should_receive(:destroy)
      post :destroy, id: 1
    end
    it "assigns the requested movie to @movie" do
      movie = stub_model(Movie, id: 1, director: nil)
      Movie.stub(:find).and_return(movie)
      movie.stub(:destroy)
      post :destroy, id: 1
      assigns(:movie).should eq(movie)
    end
    it "redirects to home page" do
      movie = stub_model(Movie, id: 1, director: nil)
      Movie.stub(:find).and_return(movie)
      movie.stub(:destroy)
      post :destroy, id: 1
      response.should redirect_to movies_path
    end
  end

end
