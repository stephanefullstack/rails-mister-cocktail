class CreateDoses < ActiveRecord::Migration[6.0]
  def change
    create_table :doses do |t|
      t.text :description
      t.references :cocktail
      t.references :ingredient

      t.timestamps
    end
  end
end
