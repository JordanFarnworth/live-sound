module PatternHelper
  EMAIL_PATTERN = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
  ENTITY_ROUTES = /(bands|enterprises|private_parties|users)/
  EVENT_ROUTES = /(events)/
  MEMBERSHIP_ROUTES = /(events|bands|enterprises|private_parties|users)/
end
