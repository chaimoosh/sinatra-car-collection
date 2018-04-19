class Car < ActiveRecord::Base
  belongs_to :user

  def owner
    self.user.name
  end
end
