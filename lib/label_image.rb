require 'open3'

module LabelImage
  BIN    = Settings.label_image.bin
  GRAPH  = Settings.label_image.graph
  LABELS = Settings.label_image.labels

  class DependencyMissing < StandardError
  end

  class Process
    attr_reader :image_path

    def initialize(image_path)
      check_dependencies
      @image_path = image_path
    end

    def run
      command = "#{BIN} --graph=\"#{GRAPH}\" --labels=\"#{LABELS}\" --image=\"#{@image_path}\""

      _, stderr, status = Open3.capture3(command)

      labels = []
      labels = parse_output(stderr) if status.success?

      return labels
    end

    def parse_output(output)
      matches = output.split("\n").map do |line|
        m = line.match(/\]\ (.*)\ \([0-9]*\):\ ([0-9\.]*)$/)
        [m[1].downcase, m[2].to_f]
      end

      Hash[matches]
    end

    private

    def check_dependencies
      [BIN, GRAPH, LABELS].each do |path|
        raise DependencyMissing.new(path) unless File.exist?(path)
      end
    end
  end
end
