class Treat::Languages::Italian
  
  RequiredDependencies = []
  OptionalDependencies = []
  
  Extractors = {}
  Inflectors = {}
  Lexicalizers = {}
  Processors = {
    :chunkers => [:txt],
    :parsers => [:stanford],
    :segmenters => [:punkt],
    :tokenizers => [:perl, :tactful]
  }
  Retrievers = {}
  
end
