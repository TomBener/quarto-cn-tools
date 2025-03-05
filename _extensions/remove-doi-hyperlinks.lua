--- Remove hyperlinks from DOIs while preserving the DOI text

--- Copyright: © 2024–Present Tom Ben
--- License: MIT License

function Link(el)
    -- Check if this is a DOI link
    if el.target:match("^https?://doi%.org") then
        -- Return just the link text content without the link wrapper
        return el.content
    end
    return el
end
