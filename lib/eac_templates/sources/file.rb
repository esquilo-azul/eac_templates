# frozen_string_literal: true

require 'eac_ruby_utils'
require 'eac_templates/abstract/file'
require 'eac_templates/sources/fs_object'

module EacTemplates
  module Sources
    class File < ::EacTemplates::Abstract::File
      include ::EacTemplates::Sources::FsObject
    end
  end
end
