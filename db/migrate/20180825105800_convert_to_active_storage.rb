class ConvertToActiveStorage < ActiveRecord::Migration[5.2]
  def up
    Rake::Task['active_storage:migrate'].invoke
  rescue StandardError => e
    $stderr.puts(e.full_message)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
