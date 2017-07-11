#module Jekyll
  class YouTube < Liquid::Tag
    #Syntax = /^\s*([^\s]+)(\s+(\d+)\s+(\d+)\s*)?/
    Syntax = /^\s*([^\s]+)(?:\s+(\d+)\s+(\d+)\s*)?/

    def initialize(tagName, markup, tokens)
      super

      if markup =~ Syntax then
        @id = $1

        if $2.nil? then
            @width = 560
            @height = 315
        else
            @width = $2.to_i
            @height = $3.to_i
        end
      else
        raise "No YouTube ID provided in the \"youtube\" tag"
      end
    end

    def render(context)
      # "<iframe width=\"#{@width}\" height=\"#{@height}\" src=\"http://www.youtube.com/embed/#{@id}\" frameborder=\"0\"allowfullscreen></iframe>"
      "<iframe width=\"#{@width}\" height=\"#{@height}\" src=\"http://www.youtube.com/embed/#{@id}?color=white&theme=light\"></iframe>"
    end

    Liquid::Template.register_tag "youtube", self
  end

  class YouTubeMute < Liquid::Tag

    #Syntax = /^\s*([^\s]+)(\s+(\d+)\s+(\d+)\s*)?/
    Syntax = /^\s*([^\s]+)(?:\s+(\d+)\s+(\d+)\s*)?/

    def initialize(tagName, markup, tokens)
      super

      if markup =~ Syntax then
        @id = $1

        if $2.nil? && $3.nil? then
            @width = 560
            @height = 315
        else
            @width = $2.to_i
            @height = $3.to_i
        end
      else
        raise "No YouTube ID provided in the \"youtube_mute\" tag"
      end
    end

    def render(context)
      # "<iframe id=\"ytplayer\" width=\"#{@width}\" height=\"#{@height}\" src=\"http://www.youtube.com/embed/#{@id}\&html5-1&enablejsapi=1" frameborder=\"0\"allowfullscreen></iframe>"
      "<iframe id=\"ytplayer\"  width=\"#{@width}\" height=\"#{@height}\" src=\"http://www.youtube.com/embed/#{@id}?color=white&theme=light&html5-1&enablejsapi=1\"></iframe>"
    end

    Liquid::Template.register_tag "youtube_mute", self
  end
#end