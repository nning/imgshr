class RenameDeleteTokensToBossTokens < ActiveRecord::Migration
  def change
    rename_table :delete_tokens, :boss_tokens
  end
end
