require 'time'

class CrssController < ApplicationController
  @@MAX_ITEMS=30

  def feed
    uname=params[:uname]
    begin
      user=User.find_by uname: uname
      if user.nil?
        render text: 'User dose not exist!', status: 404
        return
      end
      xml=<<-EOF
<?xml version="1.0" encoding="UTF-8" ?>
<rss xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" version="2.0">
<channel>
  <title>Custom RSS for #{uname}</title>
  <link>http://115.29.178.169/crss/main.html</link>
  <description>Custome RSS source</description>
  <ttl>10</ttl>
  <lastBuildDate>#{Time.now.rfc822}</lastBuildDate>
      EOF
      user.items.order(date: :desc).each do |i|
        xml+=<<-EOF
        <item>
        <title><![CDATA[#{i.title||'Custom RSS Item'}]]></title>
        <link>#{i.link||'http://115.29.178.169/crss/main.htm'}</link>
        <description><![CDATA[#{i.data}]]></description>
        <pubDate>#{i.date.rfc822}</pubDate>
        <guid>#{uname}_#{i.id}</guid>
        </item>
        EOF
      end
      xml+=<<-EOF
</channel>
</rss>
      EOF
      #response.headers['Last-Modified']=Time.now.httpdate
      render xml: xml
    rescue Exception=>e
      render text: "[Exception] #{e}", status: 500
    end
  end

  def reg
    uname=params[:uname]
    begin
      if User.find_by(uname: uname).nil?
        User.create uname: uname
        render text: 'Success'
      else
        render text: 'User name exists', status: 409
      end
    rescue Exception=>e
      render text: "[Exception] #{e}", status: 500
    end
  end

  def new
    uname=params[:uname]
    data=params[:data]
    title=params[:title]
    link=params[:link]

    title||='Custom RSS Item'
    link||='http://115.29.178.169/crss/main.html'

    if data.nil? or data==''
      render text: 'Empty data, abort!', status: 400
      return
    end
    data=URI.unescape data
    begin
      user=User.find_by uname: uname
      if user.nil?
        render text: 'User dose not exist!', status: 404
        return
      end
      while user.items.size>=@@MAX_ITEMS
        user.items.order(:date).first.destroy
      end
      user.items.create date: Time.now, data: data, title: title, link: link
      render text: 'Success'
    rescue Exception=>e
      render text: "[Exception] #{e}", status: 500
    end
  end
end
