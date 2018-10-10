class ConvertToActiveStorage < ActiveRecord::Migration[5.2]
  def up
    Rake::Task['active_storage:migrate'].invoke
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
