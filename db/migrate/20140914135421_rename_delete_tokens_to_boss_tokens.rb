class RenameDeleteTokensToBossTokens < ActiveRecord::Migration[4.2]
  def change
    rename_table :delete_tokens, :boss_tokens
  end
end
