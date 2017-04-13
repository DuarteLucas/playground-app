class ListsController < ApplicationController

  def index
    @lists = List.all
  end

  def show
    @list = List.find(params[:id])
    @movie = Movie.new
    @user = @list.user #new user
    @movie_fb = Movie.find(params[:id])

  end

  def new
    @list = List.new
  end

  def welcome_new
    @list = List.new
  end

  def create
    # @list = List.new(params[:something])
    @list = List.new
    @list.user = current_user
    @list.name = params[:list][:name]

    # movies = Movie.find_all_by_id(params[:movie_id])
    # @list.movies << movies

    if @list.save
      redirect_to edit_list_path(@list)
    else
      render :new
    end
  end

  def update
   @list = List.find(params[:id])

   if @list.update(list_params)
      redirect_to list_path(@list)    #:action => 'show'
    else
      render :edit
    end
  end

  def edit
    @list = List.find(params[:id])
    @movie = Movie.new

    if params[:movie] && params[:movie][:name]
      @movie = params[:movie][:name]
      @results = Tmdb::Search.movie(@movie)
      @movies = @results.results
    end
  end

  def destroy
    @list = List.find(params[:id])
    @list.destroy
    redirect_to dashboard_path
  end



end
