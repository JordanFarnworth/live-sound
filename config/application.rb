require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LiveSound
  class Application < Rails::Application
    config.assets.paths << Rails.root.join("public")
    config.autoload_paths += [config.root.join('lib').to_s]

    unless Rails.env.test?
      config.before_initialize do
        if ENV['AWS_BUCKET']
          config.paperclip_defaults = {
            :storage => :s3,
            :s3_credentials => {
              :bucket => ENV['AWS_BUCKET'],
              :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
              :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
            },
            :url =>'compworks.s3.amazonaws.com',
            :path => '/:class/:attachment/:id_partition/:style/:filename',
            :s3_host_name => 's3-us-west-2.amazonaws.com'
          }
        end
      end
    end

  end
end
