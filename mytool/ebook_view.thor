#!/usr/bin/env ruby
require "thor"
class EbookView < Thor
  BOOK_DIR = "/Users/haku/Dropbox/books/ruby"
  desc "list", "list the ebooks"
  method_option :ext, :type => :string, :default => 'pdf', :aliases => "-d", :desc => "ebook type" 
  def list
    type = options[:ext]
    i = 0
    Dir.glob("#{BOOK_DIR}/**#{type}").each do |f| 
      i = i+1
      puts "#{i}: #{File.basename(f)}"
    end 
  end
  desc "view", "open the ebook"
  method_option :index, :type => :numeric, :default => 1, :aliases => "-i", :desc => "book index"
  method_option :ext, :type => :string, :default => 'pdf', :aliases => "-d", :desc => "ebook type" 
  def view
    index = options[:index]
    i = 0
    type = options[:ext]
    Dir.glob("#{BOOK_DIR}/**#{type}").each do |f|
      i = i+1
      exec "open '#{f}'" if i.equal?index
    end
  end
  def method_missing(m, *args, &block)
    index = m.to_s.to_i
    if !index.nil?
      i = 0
      Dir.glob("#{BOOK_DIR}/**pdf").each do |f|
        i = i+1
        exec "open '#{f}'" if i.equal?index
      end
    else
      super
    end
  end
end
EbookView.start
