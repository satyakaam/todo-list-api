class TagSerializer < ActiveModel::Serializer
  attributes :id, :title

  def title
    object.title.humanize
  end

  has_many :tasks
end
