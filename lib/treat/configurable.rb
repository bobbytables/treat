# This module provides configuration options for the Treat toolkit
# (enable/disable syntactic sugar, enable/disable language detection
# and set default language or language detection level.
module Treat::Configurable

  # Modify the singleton class of the base module (Treat).
  def self.extended(base)

    # Configuration options that are available for the Treat module.
    class << base
      # Symbol - default language to use when detect_language is false.
      attr_accessor :default_language
      # Boolean - detect language or use default?
      attr_accessor :detect_language
      # Symbol - the finest entity level at which to detect language.
      attr_accessor :language_detection_level
      # Boolean - whether to output debug information or not.
      attr_accessor :debug
      # Boolean - whether to silence the output of external programs.
      attr_accessor :silence
    end

    # Set the default options.
    base.module_eval do
      # Set the default language to english.
      self.default_language = :eng
      # Turn language detection off by default.
      self.detect_language = false
      # Detect the language once per document by default.
      self.language_detection_level = :document
      # Set debug to off by default.
      self.debug = false
      # Silence external programs by default.
      self.silence = true
    end

  end

  # Turn on syntactic sugar for the creation of Entities.
  #
  # All entities found under Treat::Entities will be made
  # available within the global namespace. As an example,
  # 'Treat::Entities::Word' can then be referred to as 'Word'.
  #
  # There is one exception: the Symbol class is not sweetened
  # to avoid clashing with the Symbol class defined by Ruby.
  def sweeten!
    return if @@sweetened
    @@sweetened = true
    each_entity_class do |type, klass|
      Object.class_eval do
        unless type == :Symbol
          define_method(type) do |file_or_value, options={}|
            klass.build(file_or_value, options)
          end
        end
      end
    end
  end

  # Turn off syntactic sugar.
  def unsweeten!
    return unless @@sweetened
    @@sweetened = false
    each_entity_class do |type, klass|
      Object.class_eval do
        remove_method(type)
      end unless type == :Symbol
    end
  end

  # Boolean - whether syntactic sugar is
  # enabled or not.
  def sweetened?; @@sweetened; end

  # Syntactic sugar is disabled by default.
  @@sweetened = false

  # Turn on language detection, optionally setting
  # the language detection level (finest level at
  # which language detection is performed).
  def self.detect!(level = nil)
    self.detect_language = true
    if level
      self.language_detection_level = level
    end
  end

  # Turn off language detection, optionally setting
  # a new default language to use.
  def self.undetect!(default = :english)
    self.detect_language = false
    if default
      self.default_language = default
    end
  end

  # Use the supplied language by default and
  # turn off language detection.
  def self.use(language)
    self.detect_language = false
    self.default_language = language
  end
  
  private
  # Helper method, yields each entity type and class.
  def each_entity_class
    Treat::Entities.list.each do |entity_type|
      type = cc(entity_type).intern
      klass = Treat::Entities.const_get(type, klass)
      yield type, klass
    end
  end

end
