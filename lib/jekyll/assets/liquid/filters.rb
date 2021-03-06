module Jekyll
  module Assets
    module Liquid
      module Filters
        %W(js css img image javascript stylesheet style asset_path).each do |val|
          define_method val do |path, args = ""|
            Tag.send(:new, val, "#{path} #{args}", "").render(@context)
          end
        end
      end
    end
  end
end

# Register it with Liquid, good luck from here.
Liquid::Template.register_filter(Jekyll::Assets::Liquid::Filters)
