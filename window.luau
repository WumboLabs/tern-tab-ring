-- Tern Tab Ring — cross-host circular tab traversal for Tern (window plugin).
--
-- Overrides the built-in next_tab / previous_tab commands (the user's
-- Alt+Right / Alt+Left): every tab on every connected attached host becomes
-- one circular ring. Alt+Right steps forward through it, Alt+Left walks the
-- exact same ring in reverse. Sessions and tabs are never created.

local RR = {}

--- Ids of hosts in the connected state, keyed by host id.
function RR.connected(cx)
	local connected = {}
	for _, host in ipairs(cx.hosts:list()) do
		if host.state == "connected" then
			connected[host.id] = true
		end
	end
	return connected
end

--- The traversal ring in native order: sessions in
--- `sessions:list()` order, each session's tabs by one-based position.
--- Entries carry the tab's focused pane; sessions on hosts whose connection
--- state is not "connected" drop out, shrinking the ring.
function RR.ring(cx)
	local connected = RR.connected(cx)
	local order, keep = {}, {}
	for _, managed in ipairs(cx.sessions:list()) do
		if connected[managed.host] then
			table.insert(order, managed.id)
			keep[managed.id] = true
		end
	end
	local groups = {}
	for _, tab in ipairs(cx.session:tabs()) do
		if keep[tab.session] then
			local group = groups[tab.session]
			if not group then
				group = {}
				groups[tab.session] = group
			end
			table.insert(group, tab)
		end
	end
	local ring = {}
	for _, session_id in ipairs(order) do
		local group = groups[session_id]
		if group then
			table.sort(group, function(a, b)
				return a.position < b.position
			end)
			for _, tab in ipairs(group) do
				table.insert(ring, { tab = tab.id, session = session_id, pane = tab.pane })
			end
		end
	end
	return ring
end

--- Steps `delta` entries around the ring (circular both ways) and focuses the
--- destination pane, switching session first when it differs. Returns true so
--- the overridden built-in is skipped; with fewer than two destinations this
--- is a no-op.
function RR.step(cx, delta)
	local ring = RR.ring(cx)
	local count = #ring
	if count < 2 then
		return true
	end
	local focused = cx.session:focused()
	local here = focused and cx.session:tab_of(focused) or nil
	local index
	if here then
		for i, entry in ipairs(ring) do
			if entry.tab == here then
				index = i
				break
			end
		end
	end
	local target
	if index then
		target = ring[(index - 1 + delta) % count + 1]
	elseif delta > 0 then
		target = ring[1]
	else
		target = ring[count]
	end
	local current = cx.sessions:current()
	if not current or current.id ~= target.session then
		cx.sessions:switch(target.session)
	end
	cx.layout:focus(target.pane)
	return true
end

--- Runs RR.step for `delta`, swallowing errors so a failed traversal never
--- falls through to the built-in mid-step; always consumes the chord.
local function guarded(delta)
	return function(cx)
		local ok, err = pcall(RR.step, cx, delta)
		if not ok then
			tern.log.error("rr step: " .. tostring(err):sub(1, 160))
		end
		return true
	end
end

-- Registered through guarded and the RR table so every step sees the current
-- RR.step, a failing traversal is logged instead of half-firing into the
-- built-in, and the chord is always consumed.
tern.override("next_tab", guarded(1))
tern.override("previous_tab", guarded(-1))
