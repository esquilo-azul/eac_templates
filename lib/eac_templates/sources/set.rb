# frozen_string_literal: true

require 'active_support/core_ext/object/blank'
require 'eac_templates/directory'
require 'eac_templates/file'

module EacTemplates
  module Sources
    class Set
      class << self
        def default
          @default ||= new
        end
      end

      def template(subpath, required = true)
        path = template_path(subpath)
        if path.blank?
          return nil unless required

          raise_template_not_found(subpath)
        end
        return ::EacTemplates::File.new(path) if ::File.file?(path)
        return ::EacTemplates::Directory.new(path) if ::File.directory?(path)

        raise 'Invalid branching'
      end

      # @return The absolute path of template if found, +nil+ otherwise.
      def template_path(subpath)
        included_paths.each do |included_path|
          r = search_template_in_included_path(included_path, subpath)
          return r if r
        end
        nil
      end

      def included_paths
        @included_paths ||= ::Set.new
      end

      private

      def raise_template_not_found(subpath)
        raise "Template not found for subpath \"#{subpath}\"" \
          " (Included paths: #{included_paths.to_a.join(::File::PATH_SEPARATOR)})"
      end

      def search_template_in_included_path(included_path, subpath)
        path = ::File.join(included_path, subpath)
        ::File.exist?(path) ? path : nil
      end
    end
  end
end
