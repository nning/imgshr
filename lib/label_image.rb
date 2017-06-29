require 'open3'

module LabelImage
  CONFIG    = Settings.try(:label_image)
  BIN       = CONFIG.try(:bin)
  GRAPH     = CONFIG.try(:graph)
  LABELS    = CONFIG.try(:labels)
  THRESHOLD = CONFIG.try(:threshold) || 0.25

  class DependencyMissing < StandardError
  end

  class FeatureDisabled < StandardError
  end

  class Process
    attr_reader :image_path, :labels

    def initialize(image_path)
      check_disabled
      check_dependencies

      @image_path = image_path
    end

    def run!
      command = "#{BIN} --graph=\"#{GRAPH}\" --labels=\"#{LABELS}\" --image=\"#{@image_path}\""

      _, stderr, status = Open3.capture3(command)

      @labels = []
      @labels = parse_output(stderr) if status.success?

      return @labels
    end

    def parse_output(output)
      matches = output.split("\n").map do |line|
        m = line.match(/\]\ (.*)\ \([0-9]*\):\ ([0-9\.e-]*)$/)
        [m[1].downcase, m[2].to_f]
      end

      Hash[matches]
    end

    def labels_above_threshold
      labels = []

      @labels.each do |label, score|
        labels.push(label) if score >= THRESHOLD
      end

      labels
    end

    private

    def check_disabled
      raise FeatureDisabled if !LabelImage.is_enabled?
    end

    def check_dependencies
      [BIN, GRAPH, LABELS].each do |path|
        raise DependencyMissing.new(path) unless File.exist?(path)
      end
    end
  end

  def self.is_enabled?
    !(CONFIG.nil? || BIN.nil?)
  end
end
