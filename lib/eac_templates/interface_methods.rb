# frozen_string_literal: true

module EacTemplates
  module InterfaceMethods
    COMMON = %i[apply path].freeze
    ONLY_DIRECTORY = %i[child children].freeze
    DIRECTORY = COMMON + ONLY_DIRECTORY
    ONLY_FILE = %i[apply_to_file content variables].freeze
    FILE = COMMON + ONLY_FILE
    ALL = COMMON + ONLY_DIRECTORY + ONLY_FILE
  end
end
