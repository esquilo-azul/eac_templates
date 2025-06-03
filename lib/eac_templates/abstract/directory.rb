# frozen_string_literal: true

require 'eac_ruby_utils'
require 'eac_templates/interface_methods'
require 'eac_templates/abstract/fs_object'
require 'eac_templates/variables/directory'

module EacTemplates
  module Abstract
    class Directory < ::EacTemplates::Abstract::FsObject
      enable_abstract_methods
      delegate(*::EacTemplates::InterfaceMethods::DIRECTORY - %i[child chidren], to: :applier)

      # @param basename [Pathname]
      # @return [EacTemplates::Abstract::FsObject]
      def build_child(child_basename, child_type)
        child_basename = child_basename.to_pathname
        child_type = type_list.value_validate!(child_type)
        category_module.const_get(child_type.to_s.camelize)
          .new(owner, self, child_basename, options)
      end

      # @param basename [Pathname]
      # @return [EacTemplates::Abstract::FsObject]
      def child(basename)
        basename = basename.to_pathname
        children.find { |c| c.basename == basename } ||
          raise_not_found("No child found with basename \"#{basename}\"")
      end

      # @return [Enumerable<EacTemplates::Abstract::FsObject>]
      def children
        children_basenames.map { |c_basename, c_type| build_child(c_basename, c_type) }
      end

      # @return [Hash<Pathname, Symbol>]
      def children_basenames
        raise_abstract_method __method__
      end
    end
  end
end
