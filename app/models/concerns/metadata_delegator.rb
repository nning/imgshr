module MetadataDelegator
  def self.included(base)
    base.class_eval do
      base.extend MetadataDelegator
    end
  end

  def delegate_to_metadata(*attrs)
    attrs.each do |attr|
      define_method attr do
        image_file.metadata[attr]
      end

      define_method (attr.to_s + '?').to_sym do
        !!image_file.metadata[attr]
      end
    end
  end
end
