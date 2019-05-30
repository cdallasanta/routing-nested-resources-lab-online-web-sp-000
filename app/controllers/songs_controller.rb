class SongsController < ApplicationController
  def index
    if params[:artist_id]
      begin
        @artist = Artist.find(params[:artist_id])
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "Artist not found"
        redirect_to '/artists'
      end
    end

    if @artist
      @songs = @artist.songs
    else
      @songs = Song.all
    end
  end

  def show
    begin
      @song = Song.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Song not found"
      @artist = Artist.find_by(id: params[:artist_id])
      if @artist
        redirect_to artist_songs_path(@artist)
      else
        redirect_to '/songs'
      end
    end
  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    @song = Song.find(params[:id])
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name)
  end
end
