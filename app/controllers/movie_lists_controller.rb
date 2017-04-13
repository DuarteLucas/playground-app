class MovieListsController < ApplicationController


  def add_movie
    if Movie.find_by_name(params[:title])
      @new_movie = Movie.find_by_name(params[:title])
    else
      @new_movie = Movie.new(name: params[:title], overview: params[:overview], release_date: params[:release_date], poster_url: params[:poster_url])
    end
    @new_movie.save
    new_movie_list = MovieList.new(list_id: params[:list_id], movie_id: @new_movie.id)
    new_movie_list.save
    if params[:genre_ids]
      params[:genre_ids].each do |g|
        gName = Tmdb::Genre.movie_list.select{|x| x.id == g.to_i}.first.name
        genreInDB = Genre.find_by_name(gName)
        if genreInDB
          MovieGenre.create(genre_id: genreInDB.id, movie_id: @new_movie.id)
        else
          genre = Genre.create(name: gName)
          MovieGenre.create(genre_id: genre.id, movie_id: @new_movie.id)
        end
      end
    end
    redirect_to edit_list_path(params[:list_id])
  end

  def remove_movie
   disposable_movie_list = MovieList.where(list_id: params[:list_id])
   movie_list_destroy = disposable_movie_list.where('movie_lists.movie_id = ? AND movie_lists.list_id = ?', params[:movie_id], params[:list_id]).first

   movie_list_destroy.destroy

   redirect_to edit_list_path(params[:list_id])

   end
end
