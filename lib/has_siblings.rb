require "has_siblings/version"
require "has_siblings/class_methods"

module HasSiblings
end

if Object.const_defined?("ActiveRecord")
  ActiveRecord::Base.send(:extend, HasSiblings::ClassMethods)
end
