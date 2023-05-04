# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_templates/interface_methods'

module EacTemplates
  module Modules
    class Base
      module FsObject
        def self_ancestor
          owner.self_ancestor.send(type)
        end

        delegate :found?, to: :self_ancestor
      end
    end
  end
end
