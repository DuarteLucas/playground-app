class List < ApplicationRecord
  belongs_to :user
  has_many :movie_lists, dependent: :destroy
  has_many :movies, through: :movie_lists

  include PgSearch
  multisearchable against: [:name]


  def first_movie_url
    movie = self.movies.first
    if movie.nil?
      "http://i.imgur.com/65Rkme6.png"
    else
      movie.poster_url
    end
   end

   def self.has_movies?(arr_names)
    @all_lists = List.all
    @all_lists_movies = []
    @movies_in_db = []

    @all_lists.each do |list|

      list.movies.each do |list_m|
        @all_lists_movies << list_m.name
      end

    end

    arr_names.each {|m_name| @movies_in_db << Movie.find_by_name(m_name) if @all_lists_movies.include?(m_name) }
    return @movies_in_db
   end

end
