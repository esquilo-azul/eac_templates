# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_templates/abstract/not_found_error'

module EacTemplates
  module Sources
    module FsObject
      PATH_FOR_SEARCH_PREFIX = ::Pathname.new('')

      common_concern do
        enable_abstract_methods
        enable_simple_cache
      end

      # @return [Boolean]
      def found?
        real_paths.any?
      end

      # @return [Pathname]
      def path
        real_paths.first
      end

      # @return [Pathname]
      def path_for_search_prefix
        PATH_FOR_SEARCH_PREFIX
      end

      protected

      # @return [Array<Pathname>]
      def real_paths_uncached
        source_set.included_paths.lazy.map { |source_single| source_single_search(source_single) }
          .select(&:present?)
      end

      # @param path [Pathname]
      # @return [Boolean]
      def select_path?(path)
        path.present? && path.send("#{type}?")
      end

      # @param source_single [EacTemplates::Sources::Single]
      # @return [Pathname, nil]
      def source_single_search(source_single)
        r = source_single.search(path_for_search)
        select_path?(r) ? r : nil
      end
    end
  end
end
