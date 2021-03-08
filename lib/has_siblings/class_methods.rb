require 'has_siblings/errors'

module HasSiblings
  module ClassMethods
    # This is similar to how rails defines association methods.
    # https://github.com/rails/rails/blob/3e36db4406beea32772b1db1e9a16cc1e8aea14c/activerecord/lib/active_record/associations/builder/association.rb#L102
    def has_siblings(options = {})
      *parents = options.fetch(:through)
      name = options.fetch(:name, "siblings")
      allow_nil = options.fetch(:allow_nil, false)

      reflections = parents.map do |parent|
        reflection = reflect_on_association(parent)
        fail HasSiblings::ReflectionNotFoundError.new(parent, self) if reflection.nil?
        reflection
      end
      where_scopes = reflections.map do |reflection|
        foreign_key = reflection.foreign_key
        foreign_type = reflection.foreign_type

        if reflection.polymorphic?
          "where(#{foreign_key}: #{foreign_key}, #{foreign_type}: #{foreign_type})"
        else
          "where(#{foreign_key}: #{foreign_key})"
        end
      end

      mixin = ActiveRecord.version.to_s >= "4.1" ? generated_association_methods : generated_feature_methods

      mixin.class_eval <<-CODE, __FILE__, __LINE__ + 1
        def #{name}
          unless #{allow_nil}
            return self.class.none if [#{parents.join(",")}].any?(&:nil?)
          end

          self.class.#{where_scopes.join(".")}.where.not(id: id)
        end
      CODE
    end
  end
end
