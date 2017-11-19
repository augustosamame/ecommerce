class Ecommerce::Preference < Ecommerce::Base
  serialize :value

  validates :key, presence: true, uniqueness: { case_sensitive: false, allow_blank: true }
end
