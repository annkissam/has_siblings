require 'has_siblings/errors'

module HasSiblings
  module ClassMethods
    # This is similar to how rails defines association methods.
    # https://github.com/rails/rails/blob/3e36db4406beea32772b1db1e9a16cc1e8aea14c/activerecord/lib/active_record/associations/builder/association.rb#L102
    def has_siblings(options = {})
      *parents = options.fetch(:through)
      name = options.fetch(:name, "siblings")

      parent_association_pairs = parents.map do |parent|
        reflection = reflect_on_association(parent)
        fail HasSiblings::ThroughAssociationNotFoundError.new(parent, self) if reflection.nil?
        [parent, reflection]
      end
      parent_association_name_pairs = parent_association_pairs.map do |parent, association|
        fail HasSiblings::InverseOfNotFoundError.new(parent, self) if association.inverse_of.nil?
        [parent, association.inverse_of.name]
      end
      merge_scopes = parent_association_name_pairs[1..-1].map do |parent, association_name|
        "merge(#{parent}.#{association_name})"
      end
      first_parent_association = parent_association_name_pairs[0].join(".")

      mixin = ActiveRecord.version.to_s >= "4.1" ? generated_association_methods : generated_feature_methods

      mixin.class_eval <<-CODE, __FILE__, __LINE__ + 1
        def #{name}
          return self.class.none if [#{parents.join(",")}].any?(&:nil?)
          #{([first_parent_association] + merge_scopes).join(".")}.where.not(id: id)
        end
      CODE
    end
  end
end
