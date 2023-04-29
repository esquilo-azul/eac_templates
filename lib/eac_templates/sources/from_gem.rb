# frozen_string_literal: true

require 'eac_templates/sources/set'

module EacTemplates
  module Sources
    class FromGem
      class << self
        def include_all(searcher = nil)
          ::Gem::Specification.each { |gemspec| new(gemspec, searcher).include }
        end
      end

      TEMPLATES_DIR_SUBPATH = 'template'

      common_constructor :gemspec, :searcher, default: [nil] do
        self.searcher ||= ::EacTemplates::Sources::Set.default
      end

      # @return [Boolean]
      delegate :exist?, to: :path

      # @return [Pathname]
      def include
        return nil unless exist?

        searcher.included_paths << path
        path
      end

      # @return [Pathname]
      def path
        gemspec.gem_dir.to_pathname.join(TEMPLATES_DIR_SUBPATH)
      end
    end
  end
end
