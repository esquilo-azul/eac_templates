# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'eac_templates/version'

Gem::Specification.new do |s|
  s.name        = 'eac_templates'
  s.version     = EacTemplates::VERSION
  s.authors     = ['Put here the authors']
  s.summary     = 'Put here de description.'

  s.files = Dir['{lib}/**/*']
  s.required_ruby_version = '>= 2.7'

  s.add_dependency 'eac_config', '~> 0.15'
  s.add_dependency 'eac_ruby_utils', '~> 0.127'

  s.add_development_dependency 'eac_fs', '~> 0.18', '>= 0.18.1'
  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.12'
end
