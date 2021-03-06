require 'deface'

module ForemanOrchestration
  class Engine < ::Rails::Engine
    engine_name 'foreman_orchestration'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]

    # Add any db migrations
    initializer 'foreman_orchestration.load_app_instance_data' do |app|
      ForemanOrchestration::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_orchestration.register_plugin', after: :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_orchestration do
        requires_foreman '>= 1.4'

        # TODO: Add permissions

        sub_menu :top_menu, :orchestration, :after=> :infrastructure_menu do
          menu :top_menu, :all_stacks, :url_hash => { controller: :'foreman_orchestration/stacks', action: :all }
          menu :top_menu, :new_stack, :url_hash => { controller: :'foreman_orchestration/stacks', action: :new }
          menu :top_menu, :stack_templates, :url_hash => { controller: :'foreman_orchestration/stack_templates', action: :index }
        end
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
        LayoutHelper.send(:include, ForemanOrchestration::LayoutHelperExtensions)
        ComputeResourcesController.send(:include, ForemanOrchestration::ComputeResourcesControllerExtensions)
        Foreman::Model::Openstack.send(:include, ForemanOrchestration::OpenstackExtensions)
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
