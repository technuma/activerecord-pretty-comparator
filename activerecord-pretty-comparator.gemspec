# frozen_string_literal: true

require_relative "lib/activerecord/pretty/comparator/version"

Gem::Specification.new do |spec|
  spec.name = "activerecord-pretty-comparator"
  spec.version = Activerecord::Pretty::Comparator::VERSION
  spec.authors = ["technuma"]
  spec.email = ["technuma@gmail.com"]

  spec.summary = "A simple ActiveRecord extension to support where with comparison operators (`>`, `>=`, `<`, and `<=`)."
  spec.description = "A simple ActiveRecord extension to support where with comparison operators (`>`, `>=`, `<`, and `<=`)."
  spec.homepage = "https://github.com/technuma/activerecord-pretty-comparator"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "activerecord", ">= 6.1"

  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-rspec"
  spec.add_development_dependency "sqlite3", "~> 1.4"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
