-- Get a BibTeX/BibLaTeX or CSL JSON file cited from a large database
-- Source: https://pandoc.org/lua-filters.html#pandoc.utils.references
-- https://twitter.com/pandoc_tips/status/1481910457145434113

-- *Note*: For BibLaTeX, it is needed to change the following entry name:
-- - journal -> journaltitle
-- - address -> location
-- - publisher -> institution (only for thesis)

function Pandoc(doc)
  doc.meta.references = pandoc.utils.references(doc)
  doc.meta.bibliography = nil
  return doc
end
