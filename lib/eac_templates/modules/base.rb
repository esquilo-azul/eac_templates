# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_templates/interface_methods'
require 'eac_templates/abstract/with_directory_file_methods'
require 'eac_templates/modules/ancestor'
require 'eac_templates/sources/set'
require 'eac_templates/errors/type_mismatch'

module EacTemplates
  module Modules
    class Base
      include ::EacTemplates::Abstract::WithDirectoryFileMethods
      enable_listable
      enable_simple_cache
      lists.add_symbol :option, :source_set, :subpath
      common_constructor :the_module, :options, default: [{}] do
        self.options = self.class.lists.option.hash_keys_validate!(options)
      end
      delegate(*::EacTemplates::InterfaceMethods::ONLY_DIRECTORY, to: :directory)
      delegate(*::EacTemplates::InterfaceMethods::ONLY_FILE, to: :file)
      delegate(*::EacTemplates::InterfaceMethods::COMMON, :basename, :path_for_search,
               :source_object, :type, to: :sub_fs_object)

      # @param child_basename [Pathname]
      # @param child_type [Symbol]
      # @return [EacTemplates::Modules::Base]
      def build_child(child_basename, child_type)
        r = ::EacTemplates::Modules::Base.new(
          the_module, subpath: child_subpath(child_basename), source_set: source_set
        )
        return r.validate_type(child_type) if r.found?

        raise ::EacTemplates::Errors::NotFound,
              "No child for #{self} found with basename \"#{child_basename}\""
      end

      # @return [Boolean]
      def found?
        file.found? || directory.found?
      end

      # @return [EacTemplates::SourceSet]
      def source_set
        options[OPTION_SOURCE_SET] || ::EacTemplates::Sources::Set.default
      end

      # @return [Pathname, nil]
      def subpath
        options[OPTION_SUBPATH].if_present(&:to_pathname)
      end

      # @return [String]
      def to_s
        "#{self.class}[#{the_module.name}#\"#{subpath}\"]"
      end

      # @param required_type [Symbol]
      # @return [self]
      # @raise [EacTemplates::Errors::TypeMismatch]
      def validate_type(required_type)
        return self if valid_type?(required_type)

        raise ::EacTemplates::Errors::TypeMismatch, "A #{required_type} type was expected, but a " \
                                                    "#{type} was builded"
      end

      private

      # @return [Enumerable<EacTemplates::Modules::Ancestor>]
      def ancestors_uncached
        the_module.ancestors.map { |a| ::EacTemplates::Modules::Ancestor.new(self, a) }
      end

      # @return [EacTemplates::Modules::Ancestor]
      def self_ancestor_uncached
        ancestors.find { |a| a.ancestor == the_module } || ibr
      end

      # @return [Boolean]
      def valid_type?(required_type)
        file_types = %i[file file_template]
        if file_types.include?(required_type)
          file_types.include?(type)
        else
          type == required_type
        end
      end

      require_sub __FILE__
    end
  end
end
