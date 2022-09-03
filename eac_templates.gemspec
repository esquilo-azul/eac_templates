# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'eac_templates/version'

Gem::Specification.new do |s|
  s.name        = 'eac_templates'
  s.version     = EacTemplates::VERSION
  s.authors     = ['Put here the authors']
  s.summary     = 'Put here de description.'

  s.files = Dir['{lib}/**/*']

  s.add_dependency 'eac_config', '~> 0.11', '>= 0.11.1'
  s.add_dependency 'eac_ruby_utils', '~> 0.102', '>= 0.102.1'

  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.5.1'
end
