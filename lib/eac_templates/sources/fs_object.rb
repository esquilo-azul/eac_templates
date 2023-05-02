# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_templates/abstract/not_found_error'

module EacTemplates
  module Sources
    class FsObject
      enable_abstract_methods
      enable_simple_cache
      common_constructor :source_set, :subpath do
        self.subpath = subpath.to_pathname
      end

      # @return [Boolean]
      def found?
        real_paths.any?
      end

      protected

      # @return [Class]
      def applier_class
        raise_abstract_method __method__
      end

      # @return [EacTemplates::Variables::SourceFile]
      def applier_uncached
        unless found?
          raise ::EacTemplates::Abstract::NotFoundError,
                "No #{self.class.name.downcase} found for \"#{subpath}\""
        end

        applier_class.new(real_paths.first)
      end

      # @return [Array<Pathname>]
      def real_paths_uncached
        source_set.included_paths.lazy.map { |source_single| source_single_search(source_single) }
          .select(&:present?)
      end

      # @param path [Pathname]
      # @return [Boolean]
      def select_path?(path)
        path.present?
      end

      # @param source_single [EacTemplates::Sources::Single]
      # @return [Pathname, nil]
      def source_single_search(source_single)
        r = source_single.search(subpath)
        select_path?(r) ? r : nil
      end
    end
  end
end
