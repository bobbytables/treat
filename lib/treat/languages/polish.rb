class Treat::Languages::Polish
  
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
