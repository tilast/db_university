class VirtusRawPGRepo
  def self.adapter
    @adapter
  end

  def self.adapter=(adapter)
    @adapter = adapter
  end

  def self.table(klass)
    klass.to_s.downcase + 's'
  end

  def self.find(klass, id)
    klass.new(adapter.exec("SELECT * FROM #{self.table(klass)} WHERE id=#{adapter.escape_string(id.to_s)} LIMIT 1").first)
  end

  def self.create(model)
    table   = self.table(model.class)
    columns = model.attributes.keys.map(&:to_s).join(',')
    values  = '"' + user.attributes.values.map(&:to_s).map { |item| adapter.escape_string item }.join('","') + '"'

    model.id = adapter.exec("INSERT INTO #{table} (columns) VALUES (values)").first['id']
  end

  def self.update(model)
    table   = self.table(model.class)
    values  = user.attributes.reduce('') { |acc, current| acc + ',' + current[0].to_s + '="' + adapter.escape_string(current[1].to_s) + '"' }[1..-1]
    id      = adapter.escape_string(model.id)

    adapter.exec("UPDATE #{table} SET values WHERE id = #{id}")
  end

  def self.delete(model)
    table   = self.table(model.class)
    id      = adapter.escape_string(model.id)

    adapter.exec("DELETE FROM #{table} WHERE id = #{id}")
  end

  def self.save(model)
    if model.id
      update model
    else
      create model
    end
  end
end