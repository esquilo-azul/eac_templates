# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_templates/interface_methods'
require 'eac_templates/abstract/with_directory_file_methods'

module EacTemplates
  module Modules
    class Ancestor
      include ::EacTemplates::Abstract::WithDirectoryFileMethods

      class << self
        # @param a_module [Module]
        # @return [Pathname]
        def path_for_search(a_module)
          a_module.name.underscore.to_pathname
        end
      end

      common_constructor :base, :ancestor
      delegate :subpath, :source_set, to: :base
      delegate(*::EacTemplates::InterfaceMethods::ALL + [:children_basenames], to: :sub_fs_object)

      def ancestor_path_for_search
        self.class.path_for_search(ancestor)
      end

      # @return [Pathname]
      def path_for_search
        r = ancestor_path_for_search
        subpath.if_present(r) { |v| r.join(v) }
      end

      require_sub __FILE__
    end
  end
end
