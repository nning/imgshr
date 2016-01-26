class AddBranchToFileRelease < ActiveRecord::Migration
  def change
    add_column :file_releases, :branch, :string
  end
end
