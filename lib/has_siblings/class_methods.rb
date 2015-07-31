require 'has_siblings/errors'

module HasSiblings
  module ClassMethods
    # This is similar to how rails defines association methods.
    # https://github.com/rails/rails/blob/3e36db4406beea32772b1db1e9a16cc1e8aea14c/activerecord/lib/active_record/associations/builder/association.rb#L102
    def has_siblings(options = {})
      *parents = options.fetch(:through)
      name = options.fetch(:name, "siblings")

      where_scopes = parents.map do |parent|
        reflection = reflect_on_association(parent)
        fail HasSiblings::ThroughAssociationNotFoundError.new(parent, self) if reflection.nil?
        foreign_key = reflection.foreign_key
        "where(#{foreign_key}: #{foreign_key})"
      end

      mixin = ActiveRecord.version.to_s >= "4.1" ? generated_association_methods : generated_feature_methods
      mixin.class_eval <<-CODE, __FILE__, __LINE__ + 1
        def #{name}
          self.class.#{where_scopes.join(".")}.where.not(id: id)
        end
      CODE
    end
  end
end
