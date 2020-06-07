class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.references :listener, foreign_key: true
      t.references :post, foreign_key: true

      t.timestamps
    end
  end
end
