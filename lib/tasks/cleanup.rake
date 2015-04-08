# Rake tasks to cleanup 
namespace :cleanup do
  desc 'Exports Statuses that are not in last 200 to a csv and then deletes them'
  task status: :environment do
    with_config do|_app, _host, db, _user|
      File.open("#{Rails.root}/data/archived_statuses_#{db}_#{Time.now.to_i}.csv", 'w') do |f|

        # Just write one header
        PgCsv.new(sql: Status.where(id: nil).to_sql, header: true, type: :yield).export do |row|
          f.write row
        end

        Layer.find_each do |layer|
          # grab the last 200 statuses for this layer
          last_ten = layer.statuses.last(200)

          # grab everything but the last 200
          old_statuses = Status.where(layer_id: layer.id).where.not(id: last_ten)

          # write statuses to a csv
          PgCsv.new(sql: old_statuses.to_sql, temp_file: true, temp_dir: "#{Rails.root}/data", type: :yield).export do |row|
            f.write row
          end

          # delete all old statuses
          old_statuses.delete_all
        end
      end
    end
  end

  private

  def with_config
    yield Rails.application.class.parent_name.underscore,
      ActiveRecord::Base.connection_config[:host],
      ActiveRecord::Base.connection_config[:database],
      ActiveRecord::Base.connection_config[:username]
  end
end
