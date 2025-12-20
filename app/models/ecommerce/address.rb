module Ecommerce
  class Address < ApplicationRecord
    belongs_to :user
    has_many :orders

    enum address_type: {home: 1, doorman: 2, office: 3, warehouse: 4, other: 5}
    enum shipping_or_billing: {shipping: 1, billing: 2}

    validates :street, :district, presence: true
    validates :street, length: { maximum: 85 }

    before_save :truncate_street

    attr_accessor :raw_address
    attr_accessor :full_street_address

    geocoded_by :full_street_address

    after_validation :safe_geocode, if: ->(obj){ obj.street.present? && (obj.street_changed? || obj.street2_changed? || obj.district_changed?) }

    def full_street_address
      return [street, street2, district, (city || "Lima"), (country || "Perú")].compact.join(', ')
    end

    def coordinates
      return Geocoder.search(self.full_street_address).first.data["geometry"]["location"]
    end

    def friendly_street_select
      return [name, street, street2, district].compact.join(', ')
    end

    private

    def safe_geocode
      geocode
    rescue OpenSSL::SSL::SSLError, SocketError, Timeout::Error => e
      Rails.logger.warn "Geocoding failed for address: #{e.message}"
      # Address saves without coordinates - can be geocoded later
    end

    def truncate_street
      self.street = street[0, 85] if street.present? && street.length > 85
    end

  end
end
