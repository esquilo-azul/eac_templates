# frozen_string_literal: true

require 'eac_ruby_utils'
require 'eac_templates/abstract/file'
require 'eac_templates/interface_methods'
require 'eac_templates/modules/base/fs_object'

module EacTemplates
  module Modules
    class Base
      class File < ::EacTemplates::Abstract::File
        include ::EacTemplates::Modules::Base::FsObject

        delegate(*EacTemplates::InterfaceMethods::FILE + [:template?], to: :ancestor_found)

        def basename
          ancestor_found.if_present(&:basename)
        end

        def found?
          ancestor_found.present?
        end

        private

        def ancestor_found_uncached
          owner.ancestors.lazy.map(&:file).select(&:found?).first
        end
      end
    end
  end
end
