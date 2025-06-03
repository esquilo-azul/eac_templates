# frozen_string_literal: true

require 'eac_templates/patches/module/template'

class Object
  delegate :template, to: :class
end
