class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.references :owner

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
