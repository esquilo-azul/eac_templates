# frozen_string_literal: true

RSpec.shared_context 'with modules resouces' do
  let(:a_module) do
    Module.new do
      def self.name
        'AModule'
      end
    end
  end
  let(:super_class) do
    r = Class.new do
      def self.name
        'SuperClass'
      end
    end
    r.include a_module
    r
  end
  let(:prepended_module) do
    Module.new do
      def self.name
        'PrependedModule'
      end
    end
  end
  let(:sub_class) do
    r = Class.new(super_class) do
      def self.name
        'SubClass'
      end
    end
    r.prepend(prepended_module)
    r
  end
  let(:files_dir) { __dir__.to_pathname.join('modules_resources_context_files') }
  let(:variables_source) { { vx: '_X_', vy: '_Y_' } }
  let(:source_set) do
    r = EacTemplates::Sources::Set.new
    %w[path1 path2].each do |sub|
      r.included_paths << files_dir.join(sub)
    end
    r
  end
end
