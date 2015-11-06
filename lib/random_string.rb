require 'securerandom'

module RandomString
  ALPHANUMERIC = [*('a'..'z'), *('A'..'Z'), *(0..9)].freeze

  def self.generate(size = 8, set = ALPHANUMERIC)
    l = set.size
    (0...size).map { set[SecureRandom.random_number(l)] }.join
  end
end
