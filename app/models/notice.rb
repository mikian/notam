class Notice < ActiveRecord::Base
  serialize :fields

  def parse
    # Split all lines
    raw_lines = self.text.split("\n")

    # Separate identification and created/source
    line_identifier = raw_lines.shift
    line_source     = raw_lines.pop
    line_created    = raw_lines.pop

    # Parse identifier
    if m = line_identifier.match(/(\w\d+\/\d{2}) NOTAM([N|C|R])(?: (\w\d+\/\d{2}))?/)
      self.identifier = m[1]
      self.type = m[2]
      self.reference_id = Notice.find_by(identifier: m[3]).try(:id)
    end

    self.source = line_source.gsub('SOURCE: ', '')

    # Parse created
    self.created_at = Time.use_zone('UTC') { Time.zone.parse(line_created.gsub('CREATED: ', '')) }

    # Normalise remaining text
    raw_data = raw_lines.join(' ')

    # Find our fields
    fld_headers = raw_data.scan(/([A-GQ])\)/).flatten
    fld_data    = raw_data.split(/[A-GQ]\) /)[1..-1].map(&:strip)

    self.fields = Hash[fld_headers.zip(fld_data)]
  end
end
