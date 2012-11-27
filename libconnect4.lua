local lib = {
  sizeX   = 7,
  sizeY   = 7,
  sizeWin = 4,
  grid    = {}
}

local function getPlayerAt(coords)
  return lib.grid[coords.x][coords.y]
end

local function setPlayerAt(coords, player)
  lib.grid[coords.x][coords.y] = player
end

--initialize grid to 0
lib.init = function(sizeX, sizeY)
  sizeX = sizeX or lib.sizeX
  sizeY = sizeY or lib.sizeY
  for x = 1, sizeX do
    lib.grid[x] = {}
    for y = 1, sizeY do
      setPlayerAt({x=x,y=y}, 0)
    end
  end
end

--adds a piece to the grid, stacks on top
lib.addPiece = function(x, player)
  if x > 0 and x <= lib.sizeX then
    local currCol = lib.grid[x]
    for y, currPlayer in pairs(currCol) do
      if currPlayer == 0 then
        setPlayerAt({x=x,y=y}, player)
        return y
      end
    end
  end
  return nil
end

--checks to see if a player has a piece at coordinates
local function checkPlayerAt(coords, player)
  if coords.x > 0 and coords.y > 0 and
    coords.x <= lib.sizeX and coords.y <= lib.sizeY and
    getPlayerAt(coords) == player then
    return true
  end
  return false
end

--checks a particular vector for a win
local function checkVector(coords, mod)
  local found, i, pass1, pass2 = 1, 0, true, true
  local player = getPlayerAt(coords)
  local v = {} --current vector path
  while pass1 or pass2 do
    i = i + 1
    v.x, v.y = coords.x + (mod.x * i), coords.y + (mod.y * i)
    if not checkPlayerAt(v, player) then pass1 = false end
    v.x, v.y = coords.x - (mod.x * i), coords.y - (mod.y * i)
    if not checkPlayerAt(v, player) then pass2 = false end
    -- pass1 and pass2 : add 2 found
    -- pass1 or pass2 : add 1 found
    -- no pass : end
    found = found + ((pass1 and pass2) and 2 or (pass1 or pass2) and 1 or 0)
  end

  if found >= lib.sizeWin then
    return true
  else
    return false
  end
end

--checks for a win at coordinates
lib.checkWin = function(coords)
  --check all 4 win vectors
  return
  checkVector(coords, {x=0, y=1}) or --vertical
  checkVector(coords, {x=1, y=0}) or --horizontal
  checkVector(coords, {x=1, y=1}) or --diagonal slope: 1
  checkVector(coords, {x=1, y=-1}) -- diagonal slope: -1
end

return lib
