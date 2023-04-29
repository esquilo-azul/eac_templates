# frozen_string_literal: true

require 'eac_config/node'
require 'eac_templates/variables/providers/base'

module EacTemplates
  module Variables
    module Providers
      class ConfigReader < ::EacTemplates::Variables::Providers::Base
        class << self
          def accept?(variables_source)
            return false unless variables_source.respond_to?(:entry)

            entry = variables_source.entry(:any_value)
            entry.respond_to?(:value) && entry.respond_to?(:found?)
          end
        end

        def variable_exist?(name)
          source.entry(name).found?
        end

        def variable_fetch(name)
          source.entry(name).value
        end
      end
    end
  end
end
