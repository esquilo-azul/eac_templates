# frozen_string_literal: true

require 'eac_templates/file'
require 'eac_templates/variables/fs_object'

module EacTemplates
  class Directory
    attr_reader :path

    def initialize(path)
      @path = path.is_a?(::Pathname) ? path : ::Pathname.new(path.to_s)
    end

    def apply(variables_source, directory)
      ::EacTemplates::Variables::FsObject.new(self, '.', directory, variables_source).apply
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
  end
end
