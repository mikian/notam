class NotamsController < ApplicationController
  def upload
  end

  def show
    # Parse uploaded notams
    if params[:file]
      raw = params[:file].read

      notices = raw.split("\n\n").collect{|n| Notice.new(text: n)}
      # Parse notices
      notices.map(&:parse)

      # Select only notices with aerodome hours
      notices.select!{|n| n.fields['E'] && n.fields['E'].match(/AERODROME HOURS OF OPS\/SERVICE/)}

      # Build tabular data
      @aerodomes = Hash.new{|h,k| h[k] = []}
      @weekdays = %w{MON TUE WED THU FRI SAT SUN}
      re = Regexp.new(/(MON|TUE|WED|THU|FRI|SAT|SUN)(?:-(MON|TUE|WED|THU|FRI|SAT|SUN))? ([, \d-]+|CLOSED|CLSD)/)

      notices.sort_by(&:created_at).each do |notice|
        # Parse opening hours
        open = notice.fields['E'].scan(re)
        open.each do |m|
          (@weekdays.index(m[0])..(@weekdays.index(m[1])||@weekdays.index(m[0]))).each do |i|
            @aerodomes[notice.fields['A']][i] = m[2].split(', ').map(&:strip)
          end
        end
      end
    end

  end
end
