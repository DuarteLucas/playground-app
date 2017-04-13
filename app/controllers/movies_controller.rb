class MoviesController < ApplicationController
  # before_action :find_list
  def index
    @movies = Movie.all
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
    @movie_list = MovieList.new
  end

  def create
    @list = find_list

    @movie_list = MovieList.new
    @movie_list.list = @list


  end


  def search
    @movie = Movie.new
  end

  def search_results
    @list = List.find(params[:list_id])
    @movie = params[:movie][:name]
    @results = Tmdb::Search.movie(@movie)
    @movies = @results.results
    @list = find_list
  end

  def generic_search
    print(params)
  end

  private

  def find_list
    @list = List.find(params[:list_id])
  end
end
