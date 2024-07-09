# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacTemplates
  module Sources
    class Single
      class << self
        # @param object [EacTemplates::Sources::Single, Pathname]
        # @return [EacTemplates::Sources::Single]
        def assert(object)
          return object if object.is_a?(self)

          new(object.to_pathname)
        end
      end

      common_constructor :path do
        self.path = path.to_pathname.expand_path
      end

      # @return [Pathname, nil]
      def search(subpath)
        r = path.join(subpath)
        r.exist? ? r : nil
      end

      # @return [String]
      def to_s
        "#{self.class.name}[#{path}]"
      end
    end
  end
end
