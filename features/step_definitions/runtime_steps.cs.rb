Pak(/^počkám si (\d+) vteřin(?:u|y)?$/) do |kolik|
  logger.info(" Pausing for #{kolik} seconds")
  sleep kolik.to_i.seconds
  logger.info("End of pause for #{kolik} seconds")
end
