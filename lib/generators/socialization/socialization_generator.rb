require 'rails/generators'
require 'rails/generators/migration'

STORES = %w(active_record redis)

class SocializationGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  source_root File.expand_path(File.join('templates'), File.dirname(__FILE__))
  class_option :store, :type => :string, :default => 'active_record', :description => "Type of datastore"

  def self.next_migration_number(dirname)
    if ActiveRecord::Base.timestamped_migrations
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end

  def create_migration_file
    options[:store].downcase!
    unless STORES.include?(options[:store])
      puts "Invalid store '#{options[:store]}'. The following stores are valid: #{STORES.join(', ')}."
      exit 1
    end

    copy_file "#{options[:store]}/model_follow.rb",  'app/models/follow.rb'
    copy_file "#{options[:store]}/model_like.rb",    'app/models/like.rb'
    copy_file "#{options[:store]}/model_confirm.rb",    'app/models/confirm.rb'
    copy_file "#{options[:store]}/model_deny.rb",    'app/models/deny.rb'
    copy_file "#{options[:store]}/model_wish.rb",    'app/models/wish.rb'
    copy_file "#{options[:store]}/model_favorite.rb",    'app/models/favorite.rb'
    copy_file "#{options[:store]}/model_mention.rb", 'app/models/mention.rb'

    if options[:store] == 'active_record'
      migration_template "#{options[:store]}/migration_follows.rb",  'db/migrate/create_follows.rb'
      sleep 1 # wait a second to have a unique migration timestamp
      migration_template "#{options[:store]}/migration_likes.rb",    'db/migrate/create_likes.rb'
      sleep 1 # wait a second to have a unique migration timestamp
      migration_template "#{options[:store]}/migration_confirms.rb",    'db/migrate/create_confirms.rb'
      sleep 1 # wait a second to have a unique migration timestamp
      migration_template "#{options[:store]}/migration_denies.rb",    'db/migrate/create_denies.rb'
      sleep 1 # wait a second to have a unique migration timestamp
      migration_template "#{options[:store]}/migration_wishes.rb",    'db/migrate/create_wishes.rb'
      sleep 1 # wait a second to have a unique migration timestamp
      migration_template "#{options[:store]}/migration_favorites.rb",    'db/migrate/create_favorites.rb'
      sleep 1 # wait a second to have a unique migration timestamp
      migration_template "#{options[:store]}/migration_mentions.rb", 'db/migrate/create_mentions.rb'
    end
  end
end