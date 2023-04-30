# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_templates/interface_methods'
require 'eac_templates/modules/ancestor'
require 'eac_templates/sources/set'

module EacTemplates
  module Modules
    class Base
      enable_listable
      lists.add_symbol :option, :source_set, :subpath
      common_constructor :the_module, :options, default: [{}] do
        self.options = self.class.lists.option.hash_keys_validate!(options)
      end
      delegate(*::EacTemplates::InterfaceMethods::ALL, :path_for_search, :source_object,
               to: :self_ancestor)

      # @return [EacTemplates::Modules::Ancestor]
      def self_ancestor
        @self_ancestor ||= ::EacTemplates::Modules::Ancestor.new(self, the_module)
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
