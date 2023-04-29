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

      enable_listable
      lists.add_symbol :option, :source_set, :subpath
      common_constructor :the_module, :options, default: [{}] do
        self.options = self.class.lists.option.hash_keys_validate!(options)
      end
      delegate(*::EacTemplates::InterfaceMethods::ALL, to: :source_object)

      # @return [Pathname]
      def path_for_search
        r = self.class.path_for_search(the_module)
        subpath.if_present(r) { |v| r.join(v) }
      end

      # @return [EacTemplates::Variables::SourceFile, EacTemplates::Variables::SourceNode]
      def source_object
        source_set.template(path_for_search)
      end

      # @return [EacTemplates::SourceSet]
      def source_set
        options[OPTION_SOURCE_SET] || ::EacTemplates::Sources::Set.default
      end

      # @return [Pathname, nil]
      def subpath
        options[OPTION_SUBPATH].if_present(&:to_pathname)
      end
    end
  end
end
