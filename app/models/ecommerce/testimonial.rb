module Ecommerce
  class Testimonial < ApplicationRecord

    #define_attribute_methods :total_quantity
    scope :active, -> { where(status: "active") }

    paginates_per 100

    enum status: {active: 0, inactive: 1}

    mount_uploader :video, Ecommerce::TestimonialVideoUploader
    mount_uploader :thumbnail, Ecommerce::TestimonialImageUploader

    validates_presence_of :user_fullname, :user_title, :product_name, :video, :thumbnail

    
  end
end
