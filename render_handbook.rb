#!/usr/bin/env ruby

require "cgi"

input_path = File.expand_path("kubernetes-practical-bootcamp.md", __dir__)
output_path = File.expand_path("kubernetes-practical-bootcamp.html", __dir__)
markdown = File.read(input_path, encoding: "UTF-8")

def escape_html(text)
  CGI.escapeHTML(text)
end

def inline_html(text)
  code_spans = []
  text = text.gsub(/`([^`]+)`/) do
    code_spans << "<code>#{escape_html(Regexp.last_match(1))}</code>"
    "\u0000#{code_spans.length - 1}\u0000"
  end

  text = escape_html(text)
  text = text.gsub(/\[([^\]]+)\]\(([^)]+)\)/) do
    label = Regexp.last_match(1)
    target = Regexp.last_match(2)
    %(<a href="#{target}">#{label}</a>)
  end
  text = text.gsub(%r{(https?://[^\s<]+)}) do
    url = Regexp.last_match(1)
    %(<a href="#{url}">#{url}</a>)
  end
  text = text.gsub(/\*\*(.+?)\*\*/, "<strong>\\1</strong>")
  text = text.gsub(/(?<!\*)\*([^*]+)\*(?!\*)/, "<em>\\1</em>")
  code_spans.each_with_index { |html, index| text = text.gsub("\u0000#{index}\u0000", html) }
  text
end

def heading_slug(text, used)
  slug = text.downcase.gsub(/[`*_]/, "").gsub(/[^\p{Alnum} -]/u, "").strip.gsub(/\s/, "-")
  slug = "section" if slug.empty?
  base = slug
  suffix = 1
  while used.include?(slug)
    slug = "#{base}-#{suffix}"
    suffix += 1
  end
  used << slug
  slug
end

def table_cells(line)
  line.strip.sub(/^\|/, "").sub(/\|$/, "").split("|").map(&:strip)
end

lines = markdown.lines
html = []
used_heading_ids = []
index = 0
list_type = nil
paragraph = []

flush_paragraph = lambda do
  unless paragraph.empty?
    html << "<p>#{inline_html(paragraph.join(" "))}</p>"
    paragraph.clear
  end
end

close_list = lambda do
  if list_type
    html << "</#{list_type}>"
    list_type = nil
  end
end

while index < lines.length
  line = lines[index].chomp

  if line.start_with?("```")
    flush_paragraph.call
    close_list.call
    language = line.delete_prefix("```").strip
    code = []
    index += 1
    while index < lines.length && !lines[index].start_with?("```")
      code << lines[index]
      index += 1
    end
    class_attr = language.empty? ? "" : %( class="language-#{escape_html(language)}")
    html << "<pre><code#{class_attr}>#{escape_html(code.join)}</code></pre>"
  elsif line.match?(/\A\s*\|?.+\|.+\|?\s*\z/) && index + 1 < lines.length && lines[index + 1].match?(/\A\s*\|?\s*:?-{3,}:?\s*(\|\s*:?-{3,}:?\s*)+\|?\s*\z/)
    flush_paragraph.call
    close_list.call
    headers = table_cells(line)
    index += 2
    rows = []
    while index < lines.length && lines[index].include?("|") && !lines[index].strip.empty?
      rows << table_cells(lines[index].chomp)
      index += 1
    end
    html << '<div class="table-wrap"><table><thead><tr>'
    headers.each { |cell| html << "<th>#{inline_html(cell)}</th>" }
    html << "</tr></thead><tbody>"
    rows.each do |row|
      html << "<tr>"
      headers.each_index { |cell_index| html << "<td>#{inline_html(row[cell_index] || "")}</td>" }
      html << "</tr>"
    end
    html << "</tbody></table></div>"
    next
  elsif (heading = line.match(/\A(\#{1,6})\s+(.+?)\s*#*\s*\z/))
    flush_paragraph.call
    close_list.call
    level = heading[1].length
    title = heading[2]
    id = heading_slug(title, used_heading_ids)
    html << %(<h#{level} id="#{id}">#{inline_html(title)}<a class="heading-anchor" href="##{id}" aria-label="Link to #{escape_html(title)}">#</a></h#{level}>)
  elsif line.match?(/\A\s*(---+|___+|\*\*\*+)\s*\z/)
    flush_paragraph.call
    close_list.call
    html << "<hr>"
  elsif (item = line.match(/\A\s*[-*+]\s+(.+)\z/))
    flush_paragraph.call
    close_list.call if list_type && list_type != "ul"
    html << "<ul>" unless list_type
    list_type = "ul"
    html << "<li>#{inline_html(item[1])}</li>"
  elsif (item = line.match(/\A\s*\d+\.\s+(.+)\z/))
    flush_paragraph.call
    close_list.call if list_type && list_type != "ol"
    html << "<ol>" unless list_type
    list_type = "ol"
    html << "<li>#{inline_html(item[1])}</li>"
  elsif (quote = line.match(/\A\s*>\s?(.*)\z/))
    flush_paragraph.call
    close_list.call
    html << "<blockquote><p>#{inline_html(quote[1])}</p></blockquote>"
  elsif line.strip.empty?
    flush_paragraph.call
    close_list.call
  else
    paragraph << line.strip
  end

  index += 1
end

flush_paragraph.call
close_list.call

stylesheet = <<~CSS
  :root {
    color-scheme: light;
    --paper: #f4f8f5;
    --surface: #ffffff;
    --ink: #1c2a24;
    --muted: #53665c;
    --line: #d9e5dd;
    --green: #167653;
    --green-soft: #e8f4ed;
    --coral: #b94b35;
    --code: #172a22;
    --code-ink: #edf7f0;
  }
  * { box-sizing: border-box; }
  html { scroll-behavior: smooth; scroll-padding-top: 1.25rem; }
  body { margin: 0; background: var(--paper); color: var(--ink); font: 16px/1.7 -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; }
  .topline { height: 7px; background: linear-gradient(90deg, var(--green) 0 72%, #df8265 72% 100%); }
  header { padding: 3.25rem 1.5rem 2.5rem; background: var(--surface); border-bottom: 1px solid var(--line); }
  .header-inner, main { width: min(100% - 2rem, 1100px); margin: 0 auto; }
  .eyebrow { margin: 0 0 .55rem; color: var(--green); font-size: .78rem; font-weight: 750; letter-spacing: .1em; text-transform: uppercase; }
  header h1 { max-width: 850px; margin: 0; font-size: clamp(2rem, 5vw, 3.4rem); line-height: 1.12; }
  .dek { max-width: 780px; margin: 1rem 0 0; color: var(--muted); font-size: 1.08rem; }
  .meta { display: flex; flex-wrap: wrap; gap: .55rem 1.25rem; margin-top: 1.25rem; color: var(--muted); font-size: .9rem; }
  main { padding: 2rem 0 5rem; }
  article { min-width: 0; }
  h1, h2, h3, h4 { color: #15251d; line-height: 1.28; scroll-margin-top: 1rem; }
  h1 { font-size: 2.2rem; }
  h2 { margin-top: 3rem; padding-bottom: .55rem; border-bottom: 1px solid var(--line); font-size: 1.65rem; }
  h3 { margin-top: 2rem; font-size: 1.24rem; }
  h4 { margin-top: 1.5rem; font-size: 1.05rem; }
  p, ul, ol { max-width: 84ch; }
  a { color: var(--green); text-decoration-thickness: .08em; text-underline-offset: .18em; }
  a:hover { color: var(--coral); }
  .heading-anchor { margin-left: .45rem; opacity: 0; font-size: .75em; text-decoration: none; }
  h2:hover .heading-anchor, h3:hover .heading-anchor, h4:hover .heading-anchor, .heading-anchor:focus { opacity: 1; }
  li { margin: .25rem 0; padding-left: .15rem; }
  li::marker { color: var(--green); }
  blockquote { margin: 1.4rem 0; padding: .4rem 1.1rem; border-left: 4px solid #e18b6d; background: var(--green-soft); color: #34483d; }
  blockquote p { margin: .55rem 0; }
  hr { height: 1px; margin: 2.5rem 0; border: 0; background: var(--line); }
  :not(pre) > code { padding: .12rem .34rem; border: 1px solid var(--line); border-radius: 4px; background: #edf3ef; color: #244a39; font: .9em ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; overflow-wrap: anywhere; }
  pre { max-width: 100%; margin: 1.2rem 0; padding: 1.1rem 1.25rem; overflow-x: auto; border: 1px solid #2d493a; border-radius: 6px; background: var(--code); color: var(--code-ink); line-height: 1.55; tab-size: 2; }
  pre code { color: inherit; font: .9rem/1.55 ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; }
  .table-wrap { margin: 1.2rem 0; overflow-x: auto; border: 1px solid var(--line); background: var(--surface); }
  table { width: 100%; border-collapse: collapse; font-size: .92rem; }
  th, td { padding: .65rem .75rem; border-bottom: 1px solid var(--line); text-align: left; vertical-align: top; }
  th { background: var(--green-soft); color: #1c4735; font-weight: 700; }
  tbody tr:nth-child(even) { background: #f8fbf9; }
  .contents { margin: 2rem 0 2.5rem; padding: 1.25rem 1.5rem; border: 1px solid var(--line); border-left: 4px solid var(--green); background: var(--surface); }
  .contents h2 { margin: 0 0 .5rem; padding: 0; border: 0; font-size: 1.2rem; }
  .contents ul { columns: 2; column-gap: 2rem; margin: .5rem 0 0; padding-left: 1.2rem; }
  .contents li { break-inside: avoid; }
  footer { padding: 1.5rem; border-top: 1px solid var(--line); background: var(--surface); color: var(--muted); text-align: center; font-size: .88rem; }
  @media (max-width: 650px) {
    body { font-size: 15px; }
    header { padding: 2.25rem 1rem 1.75rem; }
    .header-inner, main { width: min(100% - 1.25rem, 1100px); }
    main { padding-top: 1.25rem; }
    .contents ul { columns: 1; }
    pre { padding: .9rem; }
  }
CSS

body_html = html.join("\n")
document = <<~HTML
  <!doctype html>
  <html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="color-scheme" content="light">
    <meta name="description" content="A practical, production-minded Kubernetes learning handbook with labs, troubleshooting, Helm, and a 30-day roadmap.">
    <title>Kubernetes Practical Bootcamp</title>
    <style>
  #{stylesheet.lines.map { |line| "    #{line}" }.join}
    </style>
  </head>
  <body>
    <div class="topline" aria-hidden="true"></div>
    <header>
      <div class="header-inner">
        <p class="eyebrow">Hands-on engineering handbook</p>
        <h1>Kubernetes Practical Bootcamp</h1>
        <p class="dek">Learn, build, break, debug, improve, and apply production-minded Kubernetes practices.</p>
        <div class="meta"><span>20% theory</span><span>80% hands-on practice</span><span>Local-cluster friendly</span></div>
      </div>
    </header>
    <main>
      <article>
  #{body_html.lines.map { |line| "      #{line}" }.join}
      </article>
    </main>
    <footer>Rendered from <strong>kubernetes-practical-bootcamp.md</strong>. Edit the Markdown source, then rerun <code>ruby render_handbook.rb</code> to refresh this page.</footer>
  </body>
  </html>
HTML

File.write(output_path, document, mode: "w", encoding: "UTF-8")
puts "Generated #{output_path} from #{input_path}"