class AddGithubLoginToBossTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :boss_tokens, :github_login, :string
  end
end
