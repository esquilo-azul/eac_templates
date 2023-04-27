# frozen_string_literal: true

require 'eac_templates/patches/module/template'
require 'eac_templates/searcher'

RSpec.describe ::Module do
  def self.on_node_specs(node_name, &block)
    context "when object is \"#{node_name}\"" do # rubocop:disable RSpec/EmptyExampleGroup
      let(:node) { send(node_name) }

      instance_eval(&block)
    end
  end

  def self.dir_specs(node_name, expected_children)
    on_node_specs(node_name) do
      it do
        expect(node.children.map { |child| child.path.basename.to_path }).to(
          eq(expected_children)
        )
      end
    end
  end

  def self.file_specs_ok(node_name, expected_content, expected_apply, # rubocop:disable Metrics/AbcSize
                         expected_variables)
    on_node_specs(node_name) do
      it { expect(node.content).to eq(expected_content) }
      it { expect(node.variables).to eq(::Set.new(expected_variables)) }
      it { expect(node.apply(variables_source)).to eq(expected_apply) }

      it do
        target_file = temp_file
        node.apply_to_file(variables_source, target_file)
        expect(target_file.read).to eq(expected_apply)
      end
    end
  end

  def self.file_specs_error(node_name)
    on_node_specs(node_name) do
      it do
        expect { node }.to raise_error(::RuntimeError)
      end
    end
  end

  let(:a_module) do
    described_class.new do
      def self.name
        'AModule'
      end
    end
  end
  let(:super_class) do
    r = ::Class.new do
      def self.name
        'SuperClass'
      end
    end
    r.include a_module
    r
  end
  let(:sub_class) do
    r = ::Class.new(super_class) do
      def self.name
        'SuperClass'
      end
    end
    r
  end
  let(:files_dir) { __dir__.to_pathname.join('template_spec_files') }
  let(:variables_source) { { vx: '_X_', vy: '_Y_' } }

  let(:a) { instance.template.child('a') }
  let(:a_a) { a.child('a_a') }
  let(:a_b) { a.child('a_b') }
  let(:a_c) { a.child('a_c') }
  let(:b) { instance.template.child('b') }
  let(:c) { instance.template.child('c') }

  before do
    %w[path1 path2].each do |sub|
      ::EacTemplates::Searcher.default.included_paths << files_dir.join(sub)
    end
  end

  context 'when module is AModule' do # rubocop:disable RSpec/EmptyExampleGroup
    let(:instance) { a_module }

    dir_specs(:a, %w[a_a])
    file_specs_ok(:a_a, "A_MODULE_A_A\n", "A_MODULE_A_A\n", [])
    file_specs_error(:a_b)
    file_specs_error(:a_c)
    file_specs_ok(:b, "A_MODULE_B%%vy%%\n", "A_MODULE_B_Y_\n", %w[vy])
    file_specs_error(:c)
  end

  context 'when module is SuperClass' do # rubocop:disable RSpec/EmptyExampleGroup
    let(:instance) { super_class }

    dir_specs(:a, %w[a_b])
    file_specs_error(:a_a)
    file_specs_ok(:a_b, "SUPER_CLASS_A_B\n", "SUPER_CLASS_A_B\n", [])
    file_specs_error(:a_c)
    file_specs_ok(:b, "SUPER_CLASS_B\n", "SUPER_CLASS_B\n", [])
    file_specs_error(:c)
  end

  context 'when module is SubClass' do # rubocop:disable RSpec/EmptyExampleGroup
    let(:instance) { sub_class }

    dir_specs(:a, %w[a_b])
    file_specs_error(:a_a)
    file_specs_ok(:a_b, "SUPER_CLASS_A_B\n", "SUPER_CLASS_A_B\n", [])
    file_specs_error(:a_c)
    file_specs_ok(:b, "SUPER_CLASS_B\n", "SUPER_CLASS_B\n", [])
    file_specs_error(:c)
  end
end
