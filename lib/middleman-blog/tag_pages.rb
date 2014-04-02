require 'middleman-blog/uri_templates'

module Middleman
  module Blog
    # A sitemap resource manipulator that adds a tag page to the sitemap
    # for each tag in the associated blog
    class TagPages
      include UriTemplates

      def initialize(app, blog_controller)
        @sitemap = app.sitemap
        @blog_controller = blog_controller
        @tag_link_template = uri_template blog_controller.options.taglink
        @tag_template = blog_controller.options.tag_template
        @blog_data = blog_controller.data
      end

      # Get a path to the given tag, based on the :taglink setting.
      # @param [String] tag
      # @param [String] lang Optional
      # @return [String]
      def link(tag, lang=I18n.locale)
        apply_uri_template @tag_link_template, { tag: safe_parameterize(tag), lang: lang }
      end

      # Update the main sitemap resource list
      # @return [void]
      def manipulate_resource_list(resources)
        new_resources = @blog_data.tags.map do |filter, articles|
          tag, lang = filter
          tag_page_resource(lang, tag, articles)
        end

        resources + new_resources
      end

      private

      def tag_page_resource(lang, tag, articles)
        Sitemap::Resource.new(@sitemap, link(tag, lang)).tap do |p|
          p.proxy_to(@tag_template)

          # Add metadata in local variables so it's accessible to
          # later extensions
          p.add_metadata locals: {
            'page_type' => 'tag',
            'tagname' => tag,
            'articles' => articles,
            'blog_controller' => @blog_controller
          }
        end
      end
    end
  end
end
