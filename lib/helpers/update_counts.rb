class UpdateCounts
  def self.update_play_count
    file = File.open("db/counts.txt", 'r+')
    content = file.read
    count = content.match(/Plays: (\d+)$/)[1].to_i
    content.gsub!(/Plays: \d+/, "Plays: #{count + 1}")
    File.open("db/counts.txt", 'w') { |f| f.write(content) }
  end

  def self.update_view_count
    file = File.open("db/counts.txt", 'r+')
    content = file.read
    count = content.match(/Views: (\d+)$/)[1].to_i
    content.gsub!(/Views: \d+/, "Views: #{count + 1}")
    File.open("db/counts.txt", 'w') { |f| f.write(content) }
  end
end

#TemporaryhorSeAnnexFlusterer