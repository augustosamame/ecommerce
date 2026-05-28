module Ecommerce
  class AccountingCodeFamily < ApplicationRecord
    has_many :products, inverse_of: :accounting_code_family, dependent: :nullify

    # Combined label used by the Product form dropdown so a single option
    # represents both the accounting code and the product family.
    def code_and_family
      [accounting_code, product_family].reject(&:blank?).join(" - ")
    end
  end
end
