# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_templates/abstract/directory'
require 'eac_templates/interface_methods'
require 'eac_templates/modules/base/fs_object'

module EacTemplates
  module Modules
    class Base
      class Directory < ::EacTemplates::Abstract::Directory
        include ::EacTemplates::Modules::Base::FsObject
        delegate(*(EacTemplates::InterfaceMethods::DIRECTORY - %i[apply child children]),
                 to: :self_ancestor)

        # @param variables_source [Object]
        # @param target_path [Pathname]
        def apply(variables_source, target_path)
          target_path = target_path.to_pathname
          target_path.mkpath
          children.each do |child|
            child_apply(child, variables_source, target_path.join(child.basename))
          end
        end

        # @!method build_child(child_basename, child_type)
        #   @param child_basename [Pathname]
        #   @param child_type [Symbol]
        #   @return [EacTemplates::Modules::Base]
        delegate :build_child, to: :owner

        # @return [Hash<Pathname, Symbol>]
        def children_basenames
          owner.ancestors.select(&:directory?).each_with_object({}) do |e, a|
            ancestor_children_names(e, a)
          end
        end

        # @return [Boolean]
        def found?
          children.any?
        end

        protected

        # @param ancestor []
        # @param result [Hash<Pathname, Symbol>]
        # @return [void]
        def ancestor_children_names(ancestor, result)
          ancestor.children_basenames.each do |path, type|
            result[path] = type
          end
        end

        # @param child [EacTemplates::Modules::Base]
        # # @param variables_source [Object]
        # @param target_path [Pathname]
        def child_apply(child, variables_source, target_path)
          if child.directory?
            child.apply(variables_source, target_path)
          elsif child.file_template?
            child.apply_to_file(variables_source, target_path)
          elsif child.file?
            ::FileUtils.cp(child.path, target_path)
          else
            ibr
          end
        end
      end
    end
  end
end
