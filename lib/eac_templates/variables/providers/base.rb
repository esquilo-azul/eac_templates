# frozen_string_literal: true

require 'eac_templates/variables/not_found_error'

module EacTemplates
  module Variables
    module Providers
      class Base
        attr_reader :source

        def initialize(source)
          @source = source
        end

        def variable_value(name)
          return variable_fetch(name) if variable_exist?(name)

          raise VariableNotFoundError, "Variable \"#{name}\" not found in #{source}"
        end
      end
    end
  end
end
