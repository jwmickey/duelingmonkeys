module Jekyll

  class NewsArchivePage < Page
    def initialize(site, base, dir, year, posts)
      @site = site
      @base = base
      @dir = dir
      @name = "#{year}.html"

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'news_archive.html')
      self.data['year'] = year
      self.data['posts'] = posts
      self.data['title'] = "News Posts from #{year}"
    end
  end

  class NewsArchivePageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'news_archive'
        @posts = []
        @year = site.posts[0].date.year;
        site.posts.each do |post|
          if (post.date.year != @year)
            site.pages << NewsArchivePage.new(site, site.source, 'news', @year, @posts)
            @posts = []
          else
            @posts << post
          end
          @year = post.date.year
        end

        if (@posts.length)
          site.pages << NewsArchivePage.new(site, site.source, 'news', @year, @posts)
        end
      end
    end
  end

end