module SlugAble
  def self.included(base)
    base.class_eval do
      after_initialize do
        self.slug ||= RandomString.generate if new_record?
      end
    end
  end

  def to_param
    slug
  end

  def to_s
    slug
  end
end
