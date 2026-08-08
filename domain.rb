Types = Dry.Types()

class RustServerModel < Dry::Struct
  attribute :name, Types::String
  attribute :online, Types::Integer
end

class RustServerRepository
  def all
    raise NotImplementedError
  end

  def paginate(page: 1, per_page: 10)
    raise NotImplementedError
  end

  def popular(limit: 10)
    raise NotImplementedError
  end
end
