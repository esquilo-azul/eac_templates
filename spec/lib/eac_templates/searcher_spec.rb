# frozen_string_literal: true

require 'eac_templates/interface_methods'
require 'eac_templates/searcher'

RSpec.describe ::EacTemplates::Searcher do
  let(:files_dir) { ::File.join(__dir__, 'searcher_spec_files') }
  let(:instance) do
    r = described_class.new
    r.included_paths << ::File.join(files_dir, 'path1')
    r.included_paths << ::File.join(files_dir, 'path2')
    r
  end

  describe '#template' do
    {
      'subdir1' => :directory,
      'subdir1/file1.template' => :file,
      'subdir1/file2' => :file,
      'subdir1/file3.template' => :file,
      'does_not_exist' => :nil
    }.each do |subpath, type|
      context "when subpath is \"#{subpath}\"" do
        let(:result) { instance.template(subpath, false) }

        case type
        when :nil
          it { expect(result).to be_nil }
        when :directory
          ::EacTemplates::InterfaceMethods::DIRECTORY.each do |method_name|
            it { expect(result).to respond_to(method_name) } # rubocop:disable RSpec/RepeatedExample
          end
        when :file
          ::EacTemplates::InterfaceMethods::FILE.each do |method_name|
            it { expect(result).to respond_to(method_name) } # rubocop:disable RSpec/RepeatedExample
          end
        else ibr
        end
      end
    end
  end
end
