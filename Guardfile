#!/usr/bin/ruby
# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rspec, failed_mode: :none do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/.+\.txt$})     { |m| "spec" }
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  # watch('spec/spec_helper.rb')  { "spec" }
end
