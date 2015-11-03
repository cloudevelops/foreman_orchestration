require 'deface'

module ForemanOrchestration
  class Engine < ::Rails::Engine
    engine_name 'foreman_orchestration'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]

    # Add any db migrations
    initializer 'foreman_orchestration.load_app_instance_data' do |app|
      ForemanOrchestration::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_orchestration.register_plugin', after: :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_orchestration do
        requires_foreman '>= 1.4'

        # Add permissions
        security_block :foreman_orchestration do
          permission :view_foreman_orchestration, :'foreman_orchestration/hosts' => [:new_action]
        end

        # Add a new role called 'Discovery' if it doesn't exist
        role 'ForemanOrchestration', [:view_foreman_orchestration]

        # add menu entry
        menu :top_menu, :template,
             url_hash: { controller: :'foreman_orchestration/hosts', action: :new_action },
             caption: 'ForemanOrchestration',
             parent: :hosts_menu,
             after: :hosts

        # add dashboard widget
        widget 'foreman_orchestration_widget', name: N_('Foreman plugin template widget'), sizex: 4, sizey: 1
      end
    end

    # Precompile any JS or CSS files under app/assets/
    # If requiring files from each other, list them explicitly here to avoid precompiling the same
    # content twice.
    assets_to_precompile =
      Dir.chdir(root) do
        Dir['app/assets/javascripts/**/*', 'app/assets/stylesheets/**/*'].map do |f|
          f.split(File::SEPARATOR, 4).last
        end
      end
    initializer 'foreman_orchestration.assets.precompile' do |app|
      app.config.assets.precompile += assets_to_precompile
    end
    initializer 'foreman_orchestration.configure_assets', group: :assets do
      SETTINGS[:foreman_orchestration] = { assets: { precompile: assets_to_precompile } }
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        Host::Managed.send(:include, ForemanOrchestration::HostExtensions)
        HostsHelper.send(:include, ForemanOrchestration::HostsHelperExtensions)
      rescue => e
        Rails.logger.warn "ForemanOrchestration: skipping engine hook (#{e})"
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanOrchestration::Engine.load_seed
      end
    end

    initializer 'foreman_orchestration.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../../..', __FILE__), 'locale')
      locale_domain = 'foreman_orchestration'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end
