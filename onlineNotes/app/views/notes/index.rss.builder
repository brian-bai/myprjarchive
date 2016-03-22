xml.instruct! :xml, :version => "1.0"
  xml.rss :version => "2.0" do
    xml.channel do
      xml.title "Notes"
      xml.description "Lots of Notes"
      xml.link notes_url(:format => :rss)

      for note in @notes
        xml.item do
          xml.title note.title
          xml.description note.detail
          xml.pubDate note.created_at.to_s(:rfc822)
          xml.link note_url(note, :rss)
          xml.guid note_url(note, :rss)
      end
    end
  end
end
