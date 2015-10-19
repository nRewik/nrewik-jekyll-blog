module Jekyll
  class TKTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      #"#{@text} #{Time.now}"
      "<span class=\"yellow bold\">TK</span>"
    end
  end
end

Liquid::Template.register_tag('tk', Jekyll::TKTag)
