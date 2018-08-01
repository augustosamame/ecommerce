#raise "Must set Culqi public_key and secret_key as Ecommerce::PaymentMethod records"
Culqi.public_key = Ecommerce::PaymentMethod.find_by(name: "Card", processor: "Culqi").try(:key)
Culqi.secret_key = Ecommerce::PaymentMethod.find_by(name: "Card", processor: "Culqi").try(:secret)
