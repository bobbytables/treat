class Treat::Languages::Russian
  
  RequiredDependencies = []
  OptionalDependencies = []

  Extractors = {}
  Inflectors = {}
  Lexicalizers = {}
  Processors = {
    :chunkers => [:txt],
    :segmenters => [:punkt],
    :tokenizers => [:perl, :tactful]
  }
  Retrievers = {}
  
end