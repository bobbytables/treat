# Finds the general part of speech of an entity
# (:sentence, :noun_phrase, :verb, :adverb, etc.)
# from its tag (e.g. 'S', 'NP', 'VBZ', 'ADV', etc.).
class Treat::Lexicalizers::Categorizers::FromTag

  Pttc = Treat::Linguistics::Tags::PhraseTagToCategory
  Wttc = Treat::Linguistics::Tags::WordTagToCategory
  Ptc = Treat::Linguistics::Tags::PunctuationToCategory
  
  # Find the category of the entity from its tag.
  def self.category(entity, options = {})

    tag = entity.check_has(:tag)
    return :unknown if tag.nil? || tag == '' || entity.type == :symbol
    return :sentence if tag == 'S' || entity.type == :sentence
    return :number if entity.type == :number
    return Ptc[entity.to_s] if entity.type == :punctuation
    
    if entity.is_a?(Treat::Entities::Phrase)
      cat = Pttc[tag]
      cat = Wttc[tag] unless cat
    else
      cat = Wttc[tag]
    end

    return :unknown if cat == nil
    
    ts = nil
    
    if entity.has?(:tag_set)
      ts = entity.get(:tag_set)
    elsif entity.parent_phrase && 
      entity.parent_phrase.has?(:tag_set)
      ts = entity.parent_phrase.get(:tag_set)
    else
      raise Treat::Exception,
      "No information can be found regarding "+
      "which tag set to use."
    end

    if cat[ts]
      return cat[ts]
    else
      raise Treat::Exception,
      "The specified tag set (#{ts})" +
      " does not contain the tag #{tag} " +
      "for token #{entity.to_s}."
    end

    :unknown

  end

end
