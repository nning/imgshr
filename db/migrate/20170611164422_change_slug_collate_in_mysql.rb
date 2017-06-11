class ChangeSlugCollateInMysql < ActiveRecord::Migration[5.1]
  TABLES = %w[boss_tokens device_links galleries temp_links]

  def up
    change_collation(TABLES, 'utf8_bin')
  end

  def down
    change_collation(TABLES, 'utf8_general_ci')
  end

  private

  def change_collation(tables, collation)
    if ActiveRecord::Base.connection.adapter_name == 'Mysql2'
      tables.each do |table|
        sql = 'alter table `%s` change `slug` `slug` varchar(255)
          character set utf8 collate %s not null' % [table, collation]

        execute sql.gsub(/\ {2,}/, '')
          .gsub(/\n/, ' ')
      end
    end
  end
end
