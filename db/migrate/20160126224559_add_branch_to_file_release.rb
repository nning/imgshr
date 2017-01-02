class AddBranchToFileRelease < ActiveRecord::Migration[4.2]
  def change
    add_column :file_releases, :branch, :string
  end
end
