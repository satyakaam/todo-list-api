class Task < ApplicationRecord
  has_and_belongs_to_many :tags

  validates :title, presence: true

  ##
  # Associating tags to the task
  # @param tags[Array<Tag|String>]
  # @return [Array<Tag>]
  def tags=(tags)
    raise ActiveRecord::AssociationTypeMismatch,
      "Array of String(##{String.object_id}) expected, got #{tags.inspect}" unless valid_tags_type?(tags)
    if tags.first.is_a?(String)
      tags = tags.reject(&:blank?).map do |title|
        Tag.find_or_initialize_by(title: title.parameterize.underscore)
      end
    end
    super
  end

  private

  ##
  # Validates given tags array for associating tags
  # @param tags[Array]
  # @return [Boolean]
  def valid_tags_type?(tags)
    return false unless ['Array', 'Tag::ActiveRecord_Relation'].include?(tags.class.to_s)
    return false unless tags.map(&:class).uniq.one?
    return tags.first.class == String || tags.first.class == Tag
  end
end
