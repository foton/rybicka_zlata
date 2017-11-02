# frozen_string_literal: true

Pak(/^počkám(?: si)? (\d+) (?:sekund|vteřin)(?:u|y)?$/) do |kolik|
  logger.info(" Pausing for #{kolik} seconds")
  sleep kolik.to_i.seconds
  logger.info("End of pause for #{kolik} seconds")
end
