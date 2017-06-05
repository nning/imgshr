module SlugAble
  def self.included(base)
    base.class_eval do
      after_initialize do
        self.slug ||= generate_slug if new_record?
      end
    end
  end

  def regenerate_slug!
    update_attributes!(slug: generate_slug)
  end

  def to_param
    slug
  end

  def to_s
    slug
  end

  protected

  def generate_slug
    RandomString.generate
  end
end
