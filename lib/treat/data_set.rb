class Treat::DataSet

  require 'psych'
  require 'treat/classification'
  
  attr_reader :classification
  attr_reader :labels
  attr_reader :items
  
  def self.open(file)
    unless File.readable?(file)
      raise Treat::Exception,
      "Cannot load data set "+
      "from #{file} because " +
      "it doesn't exist."
    end
    ::Psych.load(
    File.read(file))
  end
  
  def initialize(classification)
    @classification = classification
    @labels = classification.labels
    @items = []
  end
  
  def <<(entity)
    items << 
    @classification.
    export_item(entity)
  end
  
  def save(file)
    File.open(file, 'w') do |f|
      f.write(::Psych.dump(self))
    end
  end
  
end