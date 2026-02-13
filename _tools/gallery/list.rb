#!/usr/bin/env ruby
#
# Generates a galleries.json manifest from the S3 bucket.
#
# Prerequisites:
#   gem install aws-sdk-s3
#   AWS credentials configured (~/.aws/credentials or environment variables)
#
# Usage:
#   ruby list.rb > galleries.json
#
# Then upload it to S3:
#   aws s3 cp galleries.json s3://content.duelingmonkeys.com/gallery/galleries.json \
#     --content-type application/json --acl public-read
#
# The gallery page at /gallery/ fetches this file client-side.
# Image structure expected in S3:
#   gallery/<name>/<image>.jpg        (full-size images)
#   gallery/<name>/thumbs/<image>.jpg (thumbnails)
#

require "aws-sdk-s3"
require "json"

BUCKET = "content.duelingmonkeys.com"
PREFIX = "gallery"
IMAGE_EXTENSIONS = %w[.jpg .jpeg .png .gif .webp]

def generate_manifest
  s3 = Aws::S3::Bucket.new(BUCKET)
  objects = s3.objects(prefix: "#{PREFIX}/")

  galleries = {}

  objects.each do |obj|
    parts = obj.key.split("/")
    next if parts.length < 3

    gallery_name = parts[1]
    next if gallery_name.nil? || gallery_name.empty?
    next if parts[2] == "thumbs"

    ext = File.extname(parts.last).downcase
    next unless IMAGE_EXTENSIONS.include?(ext)

    galleries[gallery_name] ||= {
      "name"   => gallery_name,
      "title"  => gallery_name.gsub(/[-_]/, " ").split.map(&:capitalize).join(" "),
      "cover"  => nil,
      "images" => []
    }

    image_name = parts[2]
    galleries[gallery_name]["images"] << image_name
    galleries[gallery_name]["cover"] ||= image_name
  end

  manifest = {
    "galleries" => galleries.values.sort_by { |g| g["name"] }
  }

  puts JSON.pretty_generate(manifest)
end

generate_manifest if $PROGRAM_NAME == __FILE__