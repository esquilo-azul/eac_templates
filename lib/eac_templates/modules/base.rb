# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_templates/interface_methods'
require 'eac_templates/sources/set'

module EacTemplates
  module Modules
    class Base
      class << self
        # @param a_module [Module]
        # @return [Pathname]
        def path_for_search(a_module)
          a_module.name.underscore.to_pathname
        end
      end

      common_constructor :the_module
      delegate(*::EacTemplates::InterfaceMethods::ALL, to: :source_object)

      # @return [Pathname]
      def path_for_search
        self.class.path_for_search(the_module)
      end

      # @return [EacTemplates::Variables::SourceFile, EacTemplates::Variables::SourceNode]
      def source_object
        source_set.template(path_for_search)
      end

      # @return [EacTemplates::SourceSet]
      def source_set
        ::EacTemplates::Sources::Set.default
      end
    end
  end
end
