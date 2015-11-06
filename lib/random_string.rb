require 'securerandom'

module RandomString
  ALPHANUMERIC = [*('a'..'z'), *('A'..'Z'), *(0..9)].freeze
  TOKEN_LENGTH = ::Settings.token_length || 8

  def self.generate(size = TOKEN_LENGTH, set = ALPHANUMERIC)
    l = set.size
    (0...size).map { set[SecureRandom.random_number(l)] }.join
  end
end
