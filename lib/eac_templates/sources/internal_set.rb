# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_templates/sources/single'

module EacTemplates
  module Sources
    class InternalSet < ::Set
      # @param single [EacTemplates::Sources::Single]
      # @return [self]
      def add(single)
        super(::EacTemplates::Sources::Single.assert(single))
      end

      # @param single [EacTemplates::Sources::Single]
      # @return [self]
      def <<(single)
        add(single)
      end

      # @return [String]
      def to_s
        "#{self.class.name}[#{map(&:to_s).join(', ')}]"
      end
    end
  end
end
