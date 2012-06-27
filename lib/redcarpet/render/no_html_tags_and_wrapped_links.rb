require 'action_view/helpers/tag_helper'

module Redcarpet
	module Render
		class NoHtmlTagsAndWrappedLinks < HTML
			include ActionView::Helpers::UrlHelper

			NOFOLLOW = { :rel => 'nofollow' }

			attr_accessor :output_buffer

			def initialize
      	super :filter_html => true
      end

      def postprocess(full_document)
        wrap_links_with_noindex!(full_document)
      end
      
      # This makes redcarpet a plain text 
      [
      	:block_code, :block_quote, :header, :list, :list_item,
        :paragraph, :autolink, :codespan, :double_emphasis, :emphasis,
        :triple_emphasis, :strikethrough, :superscript, :entity, :normal_text,
        :link
      ].each do |method|
        define_method method do |*args|
          args.first
        end
      end

      protected

      def wrap_links_with_noindex!(text)
		    links = URI.extract(text, %w[ http https mailto ])
		    links.uniq.each do |l|
		      wrapped_link = noindex_link_to(l, l)
		      text.gsub!(l, wrapped_link)
		    end

		    text.gsub!(%r{(\A| ){1}(www\.[\w\.]+)}) do |l|
		      $&.gsub($2, noindex_link_to(l, "http://#{l}")
		    end

		    text.html_safe
		  end

		  def noindex_link_to(*args)
		    if (options = args.last) && options.is_a?(Hash)
		      options.merge!(NOFOLLOW)
		    else
		      args << NOFOLLOW
		    end

		    content_tag(:noindex) { link_to *args }
		  end
		end
	end
end