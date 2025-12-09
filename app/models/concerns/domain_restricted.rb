module DomainRestricted
  ALLOWED_DOMAINS = ["@endpoints.news", "@endpointsnews.com"].freeze
  
  def self.allowed?(email)
    ALLOWED_DOMAINS.any? { |domain| email.to_s.end_with?(domain) }
  end
  
  def self.error_message
    "Only #{ALLOWED_DOMAINS.join(' and ')} email addresses are allowed."
  end
end
