-- main.lua
-- ASCII City Builder starter (Love2D)
-- Run with Love2D (love .)

local stock  = require("stock")
local prices = require("prices")
local crops  = require("crops")
local life = require("life")
local TILE_W, TILE_H = 10, 16 -- font cell size (approx) — adjust with font
local GRID_W, GRID_H = 80, 40

local font
local map = {}
local tilePalette = {
  ground = {ch='.', color={0.6,0.6,0.6}},
  road_h = {ch='─', color={0.85,0.85,0.85}},
  road_v = {ch='│', color={0.85,0.85,0.85}},
  road_x = {ch='+', color={0.9,0.9,0.9}},
  bush = {ch='#', color={0.2,0.5,0.2}},
  building = {ch='H', color={0.7,0.6,0.55}},
  tower = {ch='A', color={0.5,0.7,0.95}},
  park = {ch='"', color={0.45,0.8,0.45}},
  water = {ch='~', color={0.3,0.45,0.8}},
  empty = {ch=' ', color={0,0,0}}
}

  -- near the top, with your other locals




local particles = {} -- each: {x,y,vx,vy,life,glyph,alpha}

local state = {
  cursorX = math.floor(GRID_W/2),
  cursorY = math.floor(GRID_H/2),
  mode = "place", -- place / erase / pan
  selected = "building",
  money = 500,
  time = 0,
  day = true
}

local tileOrder = {"building","tower","park","road_h","water"}

local function newRow()
  local t = {}
  for x=1,GRID_W do t[x] = "ground" end
  return t
end

local function inGrid(x,y) return x>=1 and x<=GRID_W and y>=1 and y<=GRID_H end

-- Procedural city generator: simple recursive subdivision + roads + river
-- It needs newRow and inGrid defined ABOVE it, and map, GRID_W, GRID_H as locals above it.

local function generate_city()
for y=1,GRID_H do map[y] = newRow() end

  -- river
  local base = math.floor(GRID_H*0.35)
  for x=1,GRID_W do
    local yy = base + math.floor(3*math.sin(x*0.2) + love.math.noise(x*0.1)*2)
    for dy=-1,1 do
      local y = yy + dy
      if inGrid(x,y) then map[y][x] = "water" end
        end
        end

        -- roads by recursive subdivision; the block interiors are filled with bush
        local function subdiv(x1,x2,y1,y2,depth)
        if depth<=0 then
          for y=y1+1,y2-1 do
            for x=x1+1,x2-1 do
              if map[y][x] ~= "water" then map[y][x] = "bush" end
                end
                end
                return
                end

                local horizontal = (depth % 2 == 0)
                if horizontal then
                  local y = math.floor((y1+y2)/2)
                  for x=x1,x2 do if map[y] and map[y][x] ~= "water" then map[y][x] = "road_h" end end
                    subdiv(x1,x2,y1,y-1,depth-1)
                    subdiv(x1,x2,y+1,y2,depth-1)
                    else
                      local x = math.floor((x1+x2)/2)
                      for y=y1,y2 do if map[y] and map[y][x] ~= "water" then map[y][x] = "road_v" end end
                        subdiv(x1,x-1,y1,y2,depth-1)
                        subdiv(x+1,x2,y1,y2,depth-1)
                        end
                        end

                        subdiv(1,GRID_W,1,GRID_H,3)

                        -- convert intersections to road_x
                        for y=2,GRID_H-1 do
                          for x=2,GRID_W-1 do
                            local r = map[y][x]
                            if r == "road_h" or r == "road_v" then
                              local hor = (map[y][x-1] and (map[y][x-1]:find('road') or map[y][x-1]=='road_h') ) or (map[y][x+1] and (map[y][x+1]:find('road') or map[y][x+1]=='road_h'))
                              local ver = (map[y-1][x] and (map[y-1][x]:find('road') or map[y-1][x]=='road_v') ) or (map[y+1][x] and (map[y+1][x]:find('road') or map[y+1][x]=='road_v'))
                              if hor and ver then map[y][x] = "road_x" end
                                end
                                end
                                end
                                end


local function spawn_particle(x,y,glyph)
  table.insert(particles, {x=x, y=y, vx=(love.math.random()-0.5)*0.6, vy=-love.math.random()*0.8, life=1+love.math.random()*0.8, glyph = glyph or '*', alpha=1})
end
local function priceOf(tile)
if tile:find("^road") then return prices.road end
  return prices[tile] or 0
  end

  local function tryPlace(x, y)
  if map[y][x] ~= "ground" then return false end   -- clear it first
    if not stock.remove("money", priceOf(state.selected)) then return false end
      map[y][x] = state.selected
      spawn_particle(x + 0.5, y + 0.5, '+')
      return true
      end

      local function tryErase(x, y)
      local t = map[y][x]
      if t == "ground" then return false end
        if t == "bush" and not stock.remove("money", prices.clear_bush) then return false end
          map[y][x] = "ground"
          spawn_particle(x + 0.5, y + 0.5, '.')
          return true
          end

          local function tryHarvest(x, y)
          local t = map[y][x]
          if not crops.rank(t) then return false end
            map[y][x] = "ground"
            stock.add(t, 1)    -- wheat_poor / wheat_normal / wheat_good
            spawn_particle(x + 0.5, y + 0.5, '$')
            return true
            end

            local function act(x, y)   -- left click / space
               if state.mode == "harvest" then return tryHarvest(x, y) end
                return tryPlace(x, y)
                end


-- helper, above love.update
local function showChanges(changes)
if not changes then return end
  for _, c in ipairs(changes) do
    if c.kind == "born" then spawn_particle(c.x + 0.5, c.y + 0.5, '*') end
    end
end

function love.load()
font = love.graphics.newFont(14)
love.graphics.setFont(font)
TILE_W = font:getWidth('W')
TILE_H = font:getHeight()
love.window.setMode(GRID_W * TILE_W, GRID_H * TILE_H)
generate_city()
stock.add("money", 500)
end

function love.update(dt)
  state.time = state.time + dt
  if state.time > 0.5 then
    state.day = not state.day
    state.time = 0
    -- in love.update(dt), after the particle loop
    showChanges(life.update(dt, map, GRID_W, GRID_H))

  end

  -- update particles
  for i=#particles,1,-1 do
    local p = particles[i]
    p.life = p.life - dt
    p.x = p.x + p.vx
    p.y = p.y + p.vy
    p.alpha = p.life
    if p.life <= 0 then table.remove(particles,i) end
  end
end
-- in love.keypressed(k)
function love.keypressed(k)
if k == 'escape' then love.event.quit() end

  -- cursor
  if k == 'left'  then state.cursorX = math.max(1, state.cursorX - 1) end
    if k == 'right' then state.cursorX = math.min(GRID_W, state.cursorX + 1) end
      if k == 'up'    then state.cursorY = math.max(1, state.cursorY - 1) end
        if k == 'down'  then state.cursorY = math.min(GRID_H, state.cursorY + 1) end

          -- world
          if k == 'l' then life.paused = not life.paused end
            if k == ',' then local ch = life.skip(map, GRID_W, GRID_H)
              print("tick changes: " .. #ch)
              showChanges(ch)
              end

              -- tools
              if k == 'tab' then
                local idx
                for i, v in ipairs(tileOrder) do if v == state.selected then idx = i end end
                  state.selected = tileOrder[(idx % #tileOrder) + 1]
                  end
                  if k == 'h' then state.mode = (state.mode == "harvest") and "place" or "harvest" end

                    -- actions
                    if k == 'space' then act(state.cursorX, state.cursorY) end
                      if k == 'backspace' or k == 'delete' then tryErase(state.cursorX, state.cursorY) end

                        -- debug
                        if k == 'g' then generate_city() end
                          if k == 'p' then spawn_particle(state.cursorX + 0.5, state.cursorY + 0.5, '*') end
                            end

                          function love.mousepressed(mx, my, btn)
                            local tx = math.floor(mx / TILE_W) + 1
                            local ty = math.floor(my / TILE_H) + 1
                          if inGrid(tx, ty) then
                              state.cursorX, state.cursorY = tx, ty
                            if btn == 1 then act(tx, ty)
                            elseif btn == 2 then tryErase(tx, ty) end
                            end
                          end



local function drawTile(x,y,t)
  local tile = tilePalette[t] or tilePalette.ground
  local sx = (x-1) * TILE_W
  local sy = (y-1) * TILE_H
  love.graphics.setColor(tile.color)
  love.graphics.print(tile.ch, sx, sy)
end

function love.draw()
  -- background
  if state.day then love.graphics.clear(0.05,0.06,0.08)
  else love.graphics.clear(0.01,0.01,0.03) end

  -- map
  for y=1,GRID_H do
    for x=1,GRID_W do
      drawTile(x,y,map[y][x])
    end
  end

  -- particles
  for _,p in ipairs(particles) do
    love.graphics.setColor(1,1,1, math.max(0, p.alpha))
    local sx = (p.x-1)*TILE_W
    local sy = (p.y-1)*TILE_H
    love.graphics.print(p.glyph, sx, sy)
  end

  -- cursor highlight
  love.graphics.setColor(1,1,0,0.6)
  love.graphics.rectangle('line', (state.cursorX-1)*TILE_W, (state.cursorY-1)*TILE_H, TILE_W, TILE_H)

  -- HUD
  love.graphics.setColor(1,1,1)
  love.graphics.print(("Mode: %s  Tile: %s  Money: $%d  (TAB to cycle, SPACE place, DEL erase, G regen)"):format(state.mode, state.selected, state.money), 4, GRID_H * TILE_H - 18)
end
