namespace :active_storage do
  def key(instance, attachment)
    SecureRandom.uuid
  end

  def checksum(attachment)
    url = attachment.path
    Digest::MD5.base64digest(File.read(url))
  end


  namespace :migrate do
    desc 'Migrate paperclip database entries to ActiveStorage'
    task :db => :environment do
      Dir[Rails.root.join("app/models/**/*.rb")].sort.each { |file| require file }

      old_logger = ActiveRecord::Base.logger
      ActiveRecord::Base.logger = Logger.new($stdout)

      config = Rails.configuration.database_configuration
      adapter = config[Rails.env]['adapter']

      get_blob_id = case adapter
      when 'postgresql'
        'LASTVAL()'
      when 'mysql2'
        'LAST_INSERT_ID()'
      when 'sqlite3'
        'LAST_INSERT_ROWID()'
      end

      name_map = {
        'Picture' => {
          'image' => 'image_file'
        },
        'FileRelease' => {
          'file' => 'download'
        }
      }

      active_storage_blob_statement = ActiveRecord::Base.connection.raw_connection.prepare(<<-SQL)
        INSERT INTO active_storage_blobs (
          `key`, filename, content_type, metadata, byte_size, checksum, created_at
        ) VALUES (?, ?, ?, '{}', ?, ?, ?)
      SQL

      active_storage_attachment_statement = ActiveRecord::Base.connection.raw_connection.prepare(<<-SQL)
        INSERT INTO active_storage_attachments (
          name, record_type, record_id, blob_id, created_at
        ) VALUES (?, ?, ?, #{get_blob_id}, ?)
      SQL

      models = ActiveRecord::Base.descendants.reject(&:abstract_class?)

      ActiveRecord::Base.transaction do
        models.each do |model|
          attachments = model.column_names.map do |c|
            if c =~ /(.+)_file_name$/
              $1
            end
          end.compact

          model.find_each.each do |instance|
            attachments.each do |attachment|
              new_attachment = name_map[model.to_s][attachment]

              next if ActiveStorage::Blob.where(checksum: checksum(instance.send(attachment))).any?

              active_storage_blob_statement.execute(
                key(instance, attachment),
                instance.send("#{attachment}_file_name"),
                instance.send("#{attachment}_content_type"),
                instance.send("#{attachment}_file_size"),
                checksum(instance.send(attachment)),
                instance.updated_at.to_datetime
              )

              active_storage_attachment_statement.
                execute(
                  new_attachment,
                  model.name,
                  instance.id,
                  instance.updated_at.to_datetime
                )
            end
          end
        end
      end

      active_storage_attachment_statement.close
      active_storage_blob_statement.close

      ActiveRecord::Base.logger = old_logger
    end

    desc 'Migrate Paperclip file locations to ActiveStorage'
    task :files => :environment do
      Dir[Rails.root.join("app/models/**/*.rb")].sort.each { |file| require file }

      models = ActiveRecord::Base.descendants.reject(&:abstract_class?)

      models.each do |model|
        attachments = model.column_names.map do |c|
          if c =~ /(.+)_file_name$/
            $1
          end
        end.compact

        model.find_each.each do |instance|
          attachments.each do |attachment|
            source = instance.send(attachment).path

            blob = ActiveStorage::Blob
              .where(checksum: checksum(instance.send(attachment))).first

            dest_dir = File.join(
              "storage",
              blob.key.first(2),
              blob.key.first(4).last(2)
            )
            dest = File.join(dest_dir, blob.key)

            FileUtils.mkdir_p(dest_dir)
            next if File.exists?(dest)

            puts "#{source} -> #{dest}"
            FileUtils.cp(source, dest)
          end
        end
      end
    end
  end
end
