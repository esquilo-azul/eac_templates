# frozen_string_literal: true

require 'eac_templates/file'

module EacTemplates
  class Directory
    TEMPLATE_EXTNAME = '.template'

    attr_reader :path

    def initialize(path)
      @path = path.is_a?(::Pathname) ? path : ::Pathname.new(path.to_s)
    end

    def apply(variables_source, directory)
      TemplateNode.new(self, '.', directory, variables_source).apply
    end

    def child(subpath)
      child_path = ::File.join(path, subpath)
      return ::EacTemplates::File.new(child_path) if ::File.file?(child_path)
      return ::EacTemplates::Directory.new(child_path) if ::File.directory?(child_path)

      raise "Child \"#{subpath}\" from \"#{path}\" not found"
    end

    def children
      path.children.map do |path_child|
        child(path_child.basename.to_path)
      end
    end

    private

    def apply_fs_object(source_relative, target)
      if ::File.directory?(source_absolute(source_relative))
        apply_directory(source_relative, target)
      elsif ::File.file?(source_absolute(source_relative))
      end
    end

    def source_absolute(source_relative)
      ::File.expand_path(source_relative, path)
    end

    class TemplateNode
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
          ::EacTemplates::File.new(source_absolute).apply_to_file(
            variables_source, target_absolute
          )
        else
          ::FileUtils.cp(source_absolute, target_absolute)
        end
      end

      def child(entry)
        TemplateNode.new(source_directory, ::File.join(source_relative, entry),
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
