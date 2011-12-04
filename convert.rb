#!/usr/bin/env ruby

TRAC_DB_PATH = 'trac.db'
OUT_PATH = 'wiki'

require 'sqlite3'

db = SQLite3::Database.new(TRAC_DB_PATH)
pages = db.execute('select name, text from wiki w2 where version = (select max(version) from wiki where name = w2.name);')

pages.each do |title, body|
  File.open(File.join(OUT_PATH, title.gsub(/\s/, '') + '.rst'), 'w') do |file|
    body.gsub!(/\r/, '')
    # pre-formatted texts (not yet)
    body.gsub!(/\{\{\{([^\n]+?)\}\}\}/, '@\1@')
    body.gsub!(/\{\{\{\n#!([^\n]+?)(.+?)\}\}\}/m, '<pre><code class="\1">\2</code></pre>')
    body.gsub!(/\{\{\{(.+?)\}\}\}/m, '<pre>\1</pre>')
    # macro
    body.gsub!(/\[\[BR\]\]/, '') # not supported yet
    body.gsub!(/\[\[PageOutline.*\]\]/, '') # not supported yet
    body.gsub!(/\[\[Image\((.+?)\)\]\]/, '.. image:: \1')
    # header (modify to ensure that the line texts are always longer than header texts.)
    body.gsub!(/=====\s(.+?)\s=====/, "#{'\1'}\n.....................................................\n\n")
    body.gsub!(/====\s(.+?)\s====/,   "#{'\1'}\n:::::::::::::::::::::::::::::::::::::::::::::::::::::\n\n")
    body.gsub!(/===\s(.+?)\s===/,     "#{'\1'}\n`````````````````````````````````````````````````````\n\n")
    body.gsub!(/==\s(.+?)\s==/,       "#{'\1'}\n-----------------------------------------------------\n\n")
    body.gsub!(/=\s(.+?)\s=[\s\n]*/,  "#{'\1'}\n=====================================================\n\n")
    # table (not yet)
    body.gsub!(/\|\|/,  "|")
    # link (not yet)
    body.gsub!(/\[(http[^\s\[\]]+)\s([^\[\]]+)\]/, ' "\2":\1' )
    body.gsub!(/\[([^\s]+)\s(.+)\]/, ' [[\1 | \2]] ')
    body.gsub!(/([^"\/\!])(([A-Z][a-z0-9]+){2,})/, ' \1[[\2]] ')
    body.gsub!(/\!(([A-Z][a-z0-9]+){2,})/, '\1')
    # text decoration
    body.gsub!(/'''(.+)'''/, '**\1**') # bold
    body.gsub!(/''(.+)''/, '*\1*') # italic
    body.gsub!(/`(.+)`/, '``\1``') # proportional
    # itemize (not yet)
    body.gsub!(/^\s\s\s\*/, '***')
    body.gsub!(/^\s\s\*/, '**')
    body.gsub!(/^\s\*/, '*')
    body.gsub!(/^\s\s\s\d\./, '###')
    body.gsub!(/^\s\s\d\./, '##')
    body.gsub!(/^\s\d\./, '#')
    file.write(body)
  end
end
