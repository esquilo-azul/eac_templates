# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_templates/abstract/file'
require 'eac_templates/interface_methods'
require 'eac_templates/modules/ancestor/fs_object'

module EacTemplates
  module Modules
    class Ancestor
      class File < ::EacTemplates::Abstract::File
        include ::EacTemplates::Modules::Ancestor::FsObject

        TEMPLATE_EXTNAME_PATTERN =
          /#{::Regexp.quote(::EacTemplates::Variables::FsObject::TEMPLATE_EXTNAME)}\z/.freeze

        class << self
          def parse_basename(basename)
            basename.if_present do |v|
              v.to_pathname
                .to_path
                .gsub(TEMPLATE_EXTNAME_PATTERN, '')
                .to_pathname
            end
          end
        end
      end
    end
  end
end
