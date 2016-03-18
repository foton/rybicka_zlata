SimpleCov.formatters = [ SimpleCov::Formatter::HTMLFormatter]
SimpleCov.merge_timeout 60 #minutes  to merge RSPEC AND CUCUMBER TESTS  , see: https://github.com/colszowka/simplecov/issues/29

SimpleCov.start do
  coverage_dir 'code_metrics/simplecov'
  
  add_filter '/features/'
  add_filter '/spec/'
  add_filter '/test/'
  add_filter '/config/'
  add_filter '/lib/'
  add_filter '/vendor/'

 
  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Helpers', 'app/helpers'
  add_group 'Mailers', 'app/mailers'
 # simplecov takes only*.rb files not *.erb , so this was empty: add_group 'Views', 'app/views'
end


