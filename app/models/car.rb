class Car < ActiveRecord::Base
  belongs_to :user

  def owner
    self.user.name
  end

  def slug
    self.model.gsub(" ","-").downcase
  end

  def self.find_by_slug(name_slug)
    Car.all.detect{|name| name.slug == name_slug}
  end
end
