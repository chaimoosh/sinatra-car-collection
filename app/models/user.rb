class User < ActiveRecord::Base
  has_many :cars
  has_secure_password

  def slug
    self.username.gsub(" ","-").downcase
  end

  def self.find_by_slug(name_slug)
    User.all.detect{|name| name.slug == name_slug}
  end
end
