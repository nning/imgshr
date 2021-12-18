module BossTokenAble::Model
  def self.included(base)
    base.class_eval do
      has_one :boss_token, dependent: :destroy
      base.extend BossTokenAble::Model

      after_initialize do
        self.boss_token ||= BossToken.new if new_record?
      end
    end
  end
end
