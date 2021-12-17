-- Function to get the tag object from a given name
_G.getTagFromName = function(tagName)
  for _, tag in ipairs(_G.root.tags()) do
    if (tag.name == tagName) then
      return tag
    end
  end
  return nil
end
