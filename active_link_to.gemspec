# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{active_link_to}
  s.version = "0.0.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Oleg Khabarov"]
  s.date = %q{2011-07-19}
  s.description = %q{Extremely helpful when you need to add some logic that figures out if the link (or more often navigation item) is selected based on the current page or other arbitrary condition}
  s.email = %q{oleg@theworkinggroup.ca}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    "LICENSE",
    "README.md",
    "Rakefile",
    "VERSION",
    "active_link_to.gemspec",
    "init.rb",
    "lib/active_link_to.rb",
    "test/active_link_to_test.rb",
    "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/twg/active_link_to}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Marks currently active links}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

