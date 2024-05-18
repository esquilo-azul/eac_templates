# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_templates/interface_methods'
require 'eac_templates/abstract/with_directory_file_methods'
require 'eac_templates/modules/ancestor'
require 'eac_templates/sources/set'

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
      delegate(*::EacTemplates::InterfaceMethods::COMMON, :path_for_search, :source_object,
               to: :sub_fs_object)

      # @param basename [Pathname]
      # @return [EacTemplates::Abstract::FsObject]
      def child(basename)
        r = ::EacTemplates::Modules::Base.new(
          the_module, subpath: child_subpath(basename), source_set: source_set
        )
        return r if r.found?

        raise ::EacTemplates::Abstract::NotFoundError,
              "No child for #{self} found with basename \"#{basename}\""
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

      private

      # @return [Enumerable<EacTemplates::Modules::Ancestor>]
      def ancestors_uncached
        the_module.ancestors.map { |a| ::EacTemplates::Modules::Ancestor.new(self, a) }
      end

      # @return [EacTemplates::Modules::Ancestor]
      def self_ancestor_uncached
        ancestors.find { |a| a.ancestor == the_module } || ibr
      end

      require_sub __FILE__
    end
  end
end
