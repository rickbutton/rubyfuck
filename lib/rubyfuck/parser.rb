require "treetop"

module Rubyfuck
  class Parser

    def parse(data)
      data = StringIO.new(data) if data.is_a? String
      raise "must respond to :read" unless data.respond_to? :read
      
      @parser ||= Treetop.load(
        File.join(File.dirname(__FILE__), 'grammar.treetop')
      ).new

      str = data.read
      return @parser.parse(str)
    end
  end
end
