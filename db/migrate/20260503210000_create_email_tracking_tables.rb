class CreateEmailTrackingTables < ActiveRecord::Migration[7.0]
  def change
    create_table :ecommerce_email_sends do |t|
      t.bigint   :user_id
      t.string   :email
      t.string   :category, null: false  # 'bulk' | 'operational'
      t.string   :subtype                 # 'abandoned_cart', 'order_paid', 'campaign', etc.
      t.string   :subject_type            # polymorphic: Order, Cart, Campaign, ...
      t.bigint   :subject_id
      t.string   :token, null: false
      t.string   :mailer_class
      t.string   :mailer_action
      t.datetime :sent_at
      t.datetime :first_opened_at
      t.datetime :last_opened_at
      t.integer  :opens_count, default: 0, null: false
      t.datetime :first_clicked_at
      t.datetime :last_clicked_at
      t.integer  :clicks_count, default: 0, null: false
      t.timestamps
    end
    add_index :ecommerce_email_sends, :token, unique: true
    add_index :ecommerce_email_sends, :user_id
    add_index :ecommerce_email_sends, [:category, :subtype]
    add_index :ecommerce_email_sends, [:subject_type, :subject_id]
    add_index :ecommerce_email_sends, :sent_at

    create_table :ecommerce_email_clicks do |t|
      t.bigint   :email_send_id, null: false
      t.text     :url
      t.string   :ip
      t.text     :user_agent
      t.datetime :clicked_at, null: false
      t.timestamps
    end
    add_index :ecommerce_email_clicks, :email_send_id
    add_index :ecommerce_email_clicks, :clicked_at
  end
end
