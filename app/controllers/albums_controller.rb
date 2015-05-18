class ProtectedRoutes < Sinatra::Base
  get '/api/albums' do
    albums = AlbumRepo.find_by_user current_user

    json albums: albums
  end
end