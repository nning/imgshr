require Rails.root.join('lib/label_image')

class LabelImageTest < ActiveSupport::TestCase
  label_image_available = true

  begin
    PROCESS = LabelImage::Process.new('public/images/emsi.png')
  rescue LabelImage::DependencyMissing, LabelImage::FeatureDisabled
    label_image_available = false
  end

  if label_image_available
    describe 'parse' do
      subject { PROCESS.run! }

      it 'should return hash' do
        subject.is_a? Hash
      end

      it 'should return shepherd label' do
        subject['german shepherd'] > 0.3
      end
    end
  end
end
