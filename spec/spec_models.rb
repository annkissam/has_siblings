ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => ':memory:'
)

ActiveRecord::Base.connection.create_table 'mothers', force: true
class Mother < ActiveRecord::Base
  has_many :children
end

ActiveRecord::Base.connection.create_table 'fathers', force: true
class Father < ActiveRecord::Base
  has_many :children
end

ActiveRecord::Base.connection.create_table 'children', force: true do |t|
  t.integer :mother_id
  t.integer :father_id
end
class Child < ActiveRecord::Base
  belongs_to :mother, inverse_of: :children
  belongs_to :father, inverse_of: :children

  has_siblings through: [:mother, :father]
  has_siblings through: :mother, name: :step_siblings
end
