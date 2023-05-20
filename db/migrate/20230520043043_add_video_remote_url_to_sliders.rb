class AddVideoRemoteUrlToSliders < ActiveRecord::Migration[5.2]
  def change
    add_column :ecommerce_sliders, :video_remote_url, :string
  end
end
