# frozen_string_literal: true

require_relative "lib/teihitsu_training_cli/version"

Gem::Specification.new do |spec|
  spec.name          = "teihitsu_training_cli"
  spec.version       = TeihitsuTrainingCli::VERSION
  spec.authors       = ["Yuzuki Arai"]
  spec.email         = ["yudukikun5120@gmail.com"]

  spec.summary       = "teihitsu training for CLI"
  spec.description   = "A simple quiz application based on CLI."
  spec.homepage      = "https://rubygems.org/gems/teihitsu-training-cli"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org/gems/teihitsu-training-cli"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/yudukikun5120/teihitsu-training-cli"
  spec.metadata["changelog_uri"] = "https://github.com/yudukikun5120/teihitsu-training-cli/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.executables   << "trng"
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "thor", '~> 1.2', '>= 1.2.1'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
