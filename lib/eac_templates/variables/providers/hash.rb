# frozen_string_literal: true

require 'eac_templates/variables/providers/base'

module EacTemplates
  module Variables
    module Providers
      class Hash < ::EacTemplates::Variables::Providers::Base
        class << self
          def accept?(variables_source)
            variables_source.is_a?(::Hash)
          end
        end

        def initialize(source)
          super(source.with_indifferent_access)
        end

        def variable_exist?(name)
          source.key?(name)
        end

        def variable_fetch(name)
          source.fetch(name)
        end
      end
    end
  end
end
