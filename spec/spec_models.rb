ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => ':memory:'
)

# TODO: consider using Temping for these
ActiveRecord::Base.connection.create_table 'mothers', force: true
class Mother < ActiveRecord::Base
  has_many :children
end

ActiveRecord::Base.connection.create_table 'fathers', force: true
class Father < ActiveRecord::Base
  has_many :children
end

ActiveRecord::Base.connection.create_table 'children', force: true do |t|
  t.belongs_to :mother
  t.belongs_to :father

  t.belongs_to :monster, polymorphic: true
end
class Child < ActiveRecord::Base
  belongs_to :mother, inverse_of: :children
  belongs_to :father, inverse_of: :children

  belongs_to :monster, polymorphic: true

  has_siblings through: [:mother, :father]
  has_siblings through: :mother, name: :siblings_through_mother
  has_siblings through: :monster, name: :siblings_through_monster
end

ActiveRecord::Base.connection.create_table 'grinches', force: true
class Grinch < ActiveRecord::Base
  has_many :children, as: :monster
end

ActiveRecord::Base.connection.create_table 'boogeymen', force: true
class Boogeyman < ActiveRecord::Base
  has_many :children, as: :monster
end
