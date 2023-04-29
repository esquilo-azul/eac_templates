# frozen_string_literal: true

require 'eac_templates/variables/providers/base'

module EacTemplates
  module Variables
    module Providers
      class Generic < ::EacTemplates::Variables::Providers::Base
        class << self
          def accept?(variables_source)
            variables_source.is_a?(::Object)
          end
        end

        def variable_exist?(name)
          source.respond_to?(name)
        end

        def variable_fetch(name)
          source.send(name)
        end
      end
    end
  end
end
