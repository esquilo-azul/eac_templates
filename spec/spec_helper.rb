# frozen_string_literal: true

require 'eac_ruby_utils/require_sub'
require 'eac_ruby_utils/rspec/default_setup'
EacRubyUtils::Rspec.default_setup_create(File.expand_path('..', __dir__))
EacRubyUtils.require_sub(__FILE__)
