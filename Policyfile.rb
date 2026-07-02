# frozen_string_literal: true

name 'rsync'

run_list 'test::default'

%w(default simple read_only networking).each do |recipe_name|
  named_run_list recipe_name.to_sym, "test::#{recipe_name}"
end

cookbook 'rsync', path: '.'
cookbook 'apt', git: 'https://github.com/sous-chefs/apt.git', branch: 'main'
cookbook 'test', path: 'test/cookbooks/test'
