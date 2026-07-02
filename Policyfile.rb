# frozen_string_literal: true

name 'rsync'

run_list 'test::default'

cookbook 'rsync', path: '.'
cookbook 'apt', git: 'https://github.com/sous-chefs/apt.git', branch: 'main'
cookbook 'test', path: 'test/cookbooks/test'
