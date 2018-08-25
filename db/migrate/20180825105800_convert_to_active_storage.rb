class ConvertToActiveStorage < ActiveRecord::Migration[5.2]
  def up
    Rake::Task['active_storage:migrate:db'].invoke
    Rake::Task['active_storage:migrate:files'].invoke
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
