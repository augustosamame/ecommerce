Culqi.public_key = Ecommerce::PaymentMethod.find_by!(name: "Card", processor: "Culqi").key
Culqi.secret_key = Ecommerce::PaymentMethod.find_by!(name: "Card", processor: "Culqi").secret
