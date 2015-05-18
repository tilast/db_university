class AlbumRepo
  extend Repo::Delegation

  def self.find_by_user(user)
    query("SELECT * FROM albums WHERE user_id = |?|", [user.id])
  end
end