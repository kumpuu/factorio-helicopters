tableCrawler =
{
    crawl = function(t, f, lookup)
		if not lookup then
			lookup = {}
		end

		lookup[t] = true

		--Reading nil fields on game tables will trigger an error.
		--This works for now.
		if not t.__self then
			f(t)

			for k,v in pairs(t) do
				if type(v) == "table" and not lookup[v] then
					tableCrawler.crawl(v, f, lookup)
				end
			end
		end
	end,
}