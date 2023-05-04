# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_templates/abstract/fs_object_by_pathname'
require 'eac_templates/abstract/not_found_error'

module EacTemplates
  module Abstract
    class FsObject
      class << self
        # @param obj [Object]
        # @return [EacTemplates::Abstract::FsObject, EacTemplates::Abstracts::FsObjectByPathname]
        def assert(obj)
          if obj.is_a?(self)
            obj
          else
            ::EacTemplates::Abstract::FsObjectByPathname.new(obj)
          end
        end

        # @param owner [Object]
        # @param parent_object [Object, nil]
        # @param subpath [Pathname]
        # @return [EacTemplates::Abstract::FsObject]
        def by_subpath(owner, parent_object, subpath, options = {})
          r = new(owner, parent_object, nil, options)
          subpath.if_present(::Pathname.new(''), &:to_pathname).each_filename do |basename|
            parent_object = r
            r = new(owner, parent_object, basename, options)
          end
          r
        end
      end

      enable_abstract_methods
      enable_simple_cache
      enable_listable
      lists.add_symbol :option, :source_set
      lists.add_symbol :type, :directory, :file
      common_constructor :owner, :parent_object, :basename, :options, default: [{}] do
        self.basename = basename.present? ? basename.to_pathname : ::Pathname.new('')
        self.options = ::EacTemplates::Abstract::FsObject.lists.option.hash_keys_validate!(options)
      end

      # @return [EacTemplates::Variables::Directory, EacTemplates::Variables::File]
      def applier
        applier_class.new(self)
      end

      # @return [Class]
      def applier_class
        ::EacTemplates::Variables.const_get(type.to_s.camelize)
      end

      # @return [Module]
      def category_module
        self.class.module_parent
      end

      # @return [Pathname]
      def path_for_search
        if parent_object.present?
          parent_object.path_for_search.join(basename)
        else
          path_for_search_prefix.join(basename)
        end
      end

      # @return [Pathname]
      def path_for_search_prefix
        raise_abstract_method __method__
      end

      def raise_not_found(message)
        raise ::EacTemplates::Abstract::NotFoundError, message
      end

      # @return [EacTemplates::Sources::Set]
      def source_set
        options[OPTION_SOURCE_SET] || ::EacTemplates::Sources::Set.default
      end

      # @return [Symbol]
      def type
        type_list.value_validate!(self.class.name.demodulize.underscore.to_sym)
      end

      # @return [EacRubyUtils::Listable::SymbolList]
      def type_list
        ::EacTemplates::Abstract::FsObject.lists.type
      end
    end
  end
end
