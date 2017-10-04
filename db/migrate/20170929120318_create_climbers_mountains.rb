class CreateClimbersMountains < ActiveRecord::Migration[5.1]
  def change
    create_table :climbers_mountains do |t|
      t.references :mountain, foreign_key: true
      t.references :climber, foreign_key: true
    end
  end
end
