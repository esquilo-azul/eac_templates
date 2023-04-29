# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacTemplates
  module Variables
    module Providers
      require_sub __FILE__

      PROVIDERS = %w[config_reader entries_reader hash generic].map do |name|
        "eac_templates/variables/providers/#{name}".camelize.constantize
      end

      class << self
        def build(variables_source)
          PROVIDERS.each do |provider|
            return provider.new(variables_source) if provider.accept?(variables_source)
          end

          raise "Variables provider not found for #{variables_source}"
        end
      end
    end
  end
end
