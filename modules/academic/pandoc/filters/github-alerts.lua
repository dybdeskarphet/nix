local alert_types = {
  NOTE = { title = "Not", color = "blue" },
  TIP = { title = "İpucu", color = "teal" },
  IMPORTANT = { title = "Önemli", color = "purple" },
  WARNING = { title = "Uyarı", color = "orange" },
  CAUTION = { title = "Dikkat", color = "red" }
}

function Meta(meta)
  if FORMAT:match 'latex' then
    if meta['header-includes'] == nil then
      meta['header-includes'] = pandoc.MetaList({})
    elseif meta['header-includes'].t ~= 'MetaList' then
      meta['header-includes'] = pandoc.MetaList({meta['header-includes']})
    end
    meta['header-includes']:insert(pandoc.MetaBlocks({
      pandoc.RawBlock('tex', '\\usepackage{tcolorbox}')
    }))
    return meta
  end
end

function BlockQuote(bq)
  if #bq.content == 0 then return nil end
  
  local first_block = bq.content[1]
  if first_block.tag ~= 'Para' and first_block.tag ~= 'Plain' then
    return nil
  end
  
  local inlines = first_block.content
  if #inlines == 0 then return nil end
  
  local first_inline = inlines[1]
  if first_inline.tag ~= 'Str' then return nil end
  
  -- Match [!ALERT]
  local alert_name = first_inline.text:match("^%[!([A-Z]+)%]$")
  if not alert_name or not alert_types[alert_name] then
    return nil
  end
  
  local info = alert_types[alert_name]
  
  -- Remove the first inline ([!ALERT])
  table.remove(inlines, 1)
  
  -- Remove leading spaces or linebreaks
  while #inlines > 0 and (inlines[1].tag == 'Space' or inlines[1].tag == 'SoftBreak' or inlines[1].tag == 'LineBreak') do
    table.remove(inlines, 1)
  end
  
  first_block.content = inlines
  bq.content[1] = first_block
  
  if FORMAT:match 'latex' then
    local latex_title = "\\textbf{" .. info.title .. "}"
    local begin_box = "\\mbox{}\\par\\begin{tcolorbox}[" ..
      "colback=" .. info.color .. "!5!white, " ..
      "colframe=" .. info.color .. "!75!black, " ..
      "title=" .. latex_title .. ", " ..
      "arc=2pt, outer arc=2pt, " ..
      "boxrule=0.5pt, " ..
      "leftrule=3pt, " ..
      "fonttitle=\\bfseries\\color{" .. info.color .. "!75!black}, " ..
      "colbacktitle=" .. info.color .. "!5!white, " ..
      "attach title to upper, " ..
      "after title={\\par\\sffamily\\smallskip}, " ..
      "left=10pt, right=10pt, top=8pt, bottom=8pt" ..
      "]"
    
    return {
      pandoc.RawBlock('latex', begin_box),
      pandoc.Div(bq.content),
      pandoc.RawBlock('latex', '\\end{tcolorbox}')
    }
  elseif FORMAT:match 'html' or FORMAT:match 'epub' then
    local div = pandoc.Div(bq.content, {class = "alert alert-" .. alert_name:lower()})
    local title_para = pandoc.Para({pandoc.Strong({pandoc.Str(info.title)})})
    title_para.classes = {"alert-title"}
    table.insert(div.content, 1, title_para)
    return div
  end
end

function Div(div)
  for _, class in ipairs(div.classes) do
    local upper_class = class:upper()
    local info = alert_types[upper_class]
    if info then
      if FORMAT:match 'latex' then
        local latex_title = "\\textbf{" .. info.title .. "}"
        local begin_box = "\\mbox{}\\par\\begin{tcolorbox}[" ..
          "colback=" .. info.color .. "!5!white, " ..
          "colframe=" .. info.color .. "!75!black, " ..
          "title=" .. latex_title .. ", " ..
          "arc=2pt, outer arc=2pt, " ..
          "boxrule=0.5pt, " ..
          "leftrule=3pt, " ..
          "fonttitle=\\bfseries\\color{" .. info.color .. "!75!black}, " ..
          "colbacktitle=" .. info.color .. "!5!white, " ..
          "attach title to upper, " ..
          "after title={\\par\\sffamily\\smallskip}, " ..
          "left=10pt, right=10pt, top=8pt, bottom=8pt" ..
          "]"
        
        local result = {
          pandoc.RawBlock('latex', begin_box)
        }
        for _, block in ipairs(div.content) do
          table.insert(result, block)
        end
        table.insert(result, pandoc.RawBlock('latex', '\\end{tcolorbox}'))
        return result
      elseif FORMAT:match 'html' or FORMAT:match 'epub' then
        div.classes = {"alert", "alert-" .. upper_class:lower()}
        local title_para = pandoc.Para({pandoc.Strong({pandoc.Str(info.title)})})
        title_para.classes = {"alert-title"}
        table.insert(div.content, 1, title_para)
        return div
      end
    end
  end
end

