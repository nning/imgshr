class AddGithubUidToBossToken < ActiveRecord::Migration[5.0]
  def change
    add_column :boss_tokens, :github_uid, :integer
  end
end
