#!/usr/bin/env ruby

class Parser
@offices = [
  "United States Senator",
  "Governor & Lieutenant",
  "Attorney General",
  "Secretary of State",
  "Comptroller",
  "Treasurer",
  "U.S. Representative",
  "State Senator",
  "State Representative",
  "Metropolitan Water Reclamation District Commissioners",
  "President of County Board",
  "County Clerk",
  "County Sheriff",
  "County Treasurer",
  "County Assessor",
  "County Commissioner",
  "Board of Review",
  "Judge of the Appellate Court",
  "Judge of the Circuit Court",
  "Judge",
  "Judicial Retention Appellate Court",
  "Judicial Retention Circuit Court",
    ]

    offices_s = @offices.join("|")
    @@offices_re = %r{(?<office>#{offices_s})(, (?<district>\d+).* District){0,1}}

def match_office(line)
  return @@offices_re.match(line)
end

def parse(lines)
  candidates = []
  office = nil
  district = nil
  lines.each do |line|
    line = line.strip

    if line == ""
      next
    end

    m = self.match_office(line)

    if m != nil
      office = m[:office]
      district = m[:district]
      next
    end

    if office == nil
      next
    end

    puts m[:office]
    puts m[:district]
end
  return candidates
end

end

if __FILE__ == $0
  p = Parser.new()
  lines = $stdin.readlines
  candidates = p.parse(lines)
  column_names = candidates.first.keys
  csv_s = CSV.generate do |csv|
    csv << column_names
    candidates.each do |candidate|
      csv << candidate.values
    end
  end

  puts csv_s
end
