# encoding: utf-8
# Created by: mlcoch  at 2013-02-20 11:12

FAILED_DIR_PATH="tmp/capybara"

#something like Before(:suite) => just run in before suite
#cleaning previous saved failure pages
FileUtils.rm_rf(FAILED_DIR_PATH)

@locale="cs"

After do |scenario|
  if scenario.failed?
    #filename = "#{FAILED_DIR_PATH}/failed--#{scenario.file.gsub("features/","").gsub("/","-")}--#{scenario.line}.html"
    filename = "#{FAILED_DIR_PATH}/failed--#{scenario.location.file.gsub("features/","").gsub("/","-")}--#{scenario.location.line}.html"
    Capybara.save_page filename
  end
end
 
