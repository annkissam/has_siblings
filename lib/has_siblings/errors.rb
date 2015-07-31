module HasSiblings
  class ThroughAssociationNotFoundError < StandardError
    def initialize(association_name, owner_class_name)
      super("Could not find the association #{association_name} in model #{owner_class_name}")
    end
  end

  class InverseOfNotFoundError < StandardError
    def initialize(association_name, owner_class_name)
      super("Could not find the inverse_of for the association #{association_name} in model #{owner_class_name}")
    end
  end
end
