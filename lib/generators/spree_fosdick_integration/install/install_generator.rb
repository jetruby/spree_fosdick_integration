module SpreeFosdickIntegration
  module Generators
    class InstallGenerator < Rails::Generators::Base

      class_option :auto_run_migrations, type: :boolean, default: false

      def self.source_paths
        paths = self.superclass.source_paths
        # paths << File.expand_path('../templates', "../../#{__FILE__}")
        # paths << File.expand_path('../templates', "../#{__FILE__}")
        paths << File.expand_path('../templates', __FILE__)
        paths.flatten
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_fosdick_integration'
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask 'Would you like to run the migrations now? [Y/n]')
        if run_migrations
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end

      def copy_initializer
        copy_file 'fosdick.yml.template', 'config/fosdick.yml'
        copy_file 'fosdick.rb', 'config/initializers/fosdick.rb'
      end
    end
  end
end
