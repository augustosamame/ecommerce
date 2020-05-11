if ActiveRecord::Base.connection.table_exists? 'ecommerce_payment_methods'
    Culqi.public_key = Ecommerce::PaymentMethod.find_by(name: "Card", processor: "Culqi").try(:key)
    Culqi.secret_key = Ecommerce::PaymentMethod.find_by(name: "Card", processor: "Culqi").try(:secret)
end
