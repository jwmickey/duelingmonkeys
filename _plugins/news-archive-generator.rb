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
        posts = site.posts.docs
        return if posts.empty?

        posts_by_year = posts.group_by { |post| post.date.year }
        posts_by_year.keys.sort.reverse.each do |year|
          year_posts = posts_by_year[year].sort_by { |post| -post.date.to_time.to_i }
          site.pages << NewsArchivePage.new(site, site.source, 'news', year, year_posts)
        end
      end
    end
  end

end