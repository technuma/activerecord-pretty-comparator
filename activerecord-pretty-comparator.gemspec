# frozen_string_literal: true

require_relative "lib/active_record/pretty/comparator/version"

Gem::Specification.new do |spec|
  spec.name = "activerecord-pretty-comparator"
  spec.version = ActiveRecord::Pretty::Comparator::VERSION
  spec.authors = ["Kazuya Onuma", "Ryuta Kamizono"]
  spec.email = ["technuma@gmail.com", "kamipo@gmail.com"]

  spec.summary = "A simple ActiveRecord extension to support where with comparison operators (`>`, `>=`, `<`, and `<=`)."
  spec.description = "A simple ActiveRecord extension to support where with comparison operators (`>`, `>=`, `<`, and `<=`)."
  spec.homepage = "https://github.com/technuma/activerecord-pretty-comparator"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

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

  spec.add_dependency "activerecord", ">= 6.1"

  spec.add_development_dependency "bigdecimal"
  spec.add_development_dependency "base64"
  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "mutex_m"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-rspec"
  spec.add_development_dependency "sqlite3"
end
