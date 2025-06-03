# frozen_string_literal: true

require 'eac_ruby_utils'
EacRubyUtils::RootModuleSetup.perform __FILE__ do
  ignore 'core_ext'
  ignore 'patches'
  ignore 'sources/from_all_gems'
end

require 'eac_config'

module EacTemplates
end

require 'eac_templates/core_ext'
