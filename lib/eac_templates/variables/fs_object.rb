# frozen_string_literal: true

require 'eac_templates/variables/file'

module EacTemplates
  module Variables
    class FsObject
      TEMPLATE_EXTNAME = '.template'

      attr_reader :source_directory, :source_relative, :target_root_directory, :variables_source

      def initialize(source_directory, source_relative, target_root_directory, variables_source)
        @source_directory = source_directory
        @source_relative = source_relative
        @target_root_directory = target_root_directory
        @variables_source = variables_source
      end

      def apply
        if file?
          apply_file
        elsif directory?
          apply_directory
        else
          raise "Unknown filesystem type: #{source_absolute}"
        end
      end

      private

      def apply_directory
        ::FileUtils.mkdir_p(target_absolute)
        Dir.entries(source_absolute).each do |entry|
          child(entry).apply unless %w[. ..].include?(entry)
        end
      end

      def apply_file
        if ::File.extname(source_absolute) == TEMPLATE_EXTNAME
          ::EacTemplates::Variables::File.new(source_absolute).apply_to_file(
            variables_source, target_absolute
          )
        else
          ::FileUtils.cp(source_absolute, target_absolute)
        end
      end

      def child(entry)
        self.class.new(source_directory, ::File.join(source_relative, entry),
                       target_root_directory, variables_source)
      end

      def file?
        ::File.file?(source_absolute)
      end

      def directory?
        ::File.directory?(source_absolute)
      end

      def source_absolute
        ::File.expand_path(source_relative, source_directory.path)
      end

      def target_absolute
        ::File.expand_path(source_relative, target_root_directory)
          .gsub(/#{::Regexp.quote(TEMPLATE_EXTNAME)}\z/, '')
      end
    end
  end
end
