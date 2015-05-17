module Repo::Delegation
  def save(record)
    Repo.save(record)
  end

  def find(id)
    Repo.find object_class, id
  end

  def delete(record)
    Repo.delete record
  end

  def query(selector, params=[])
    raw_query(selector, params).map { |item| object_class.new(item) }
  end

  def raw_query(selector, params=[])
    Repo.query(selector, params)
  end

  private
  def object_class
    @object_class ||= self.to_s.match(/^(.+)Repo/)[1].constantize
  end
end