local sizeX, sizeY, sizeWin = 7, 7, 4
local grid = {}
local playerColor = 1

for x = 1, sizeX do
  grid[x] = {}
  for y = 1, sizeY do
    grid[x][y] = 0
  end
end
function checkWin(x, y)
  function checkVector(x, y, modX, modY)
    local found = 1
    local fail1, fail2 = false, false
    local i = 1
    local color = grid[x][y]
    while not fail1 or not fail2 do
      local currX, currY = x + (modX * i), y + (modY * i)
      if currX > 0 and currX <= sizeX and currY > 0 and currY <= sizeY and grid[currX][currY] == color and not fail1 then
        found = found + 1
      else
        fail1 = true
      end
      currX, currY = x - (modX * i), y - (modY * i)
      if currX > 0 and currX <= sizeX and currY > 0 and currY <= sizeY and grid[currX][currY] == color and not fail2 then
        found = found + 1
      else
        fail2 = true
      end
      i = i + 1
    end

    if found >= sizeWin then
      return true
    else
      return false
    end
  end

  return checkVector(x, y, 0, 1) or checkVector(x, y, 1, 0) or checkVector(x, y, 1, 1) or checkVector(x, y, 1, -1)
end

function addPiece(x, color)
  if x > 0 and x <= sizeX then
    local currCol = grid[x]
    for y, currColor in pairs(currCol) do
      if currColor == 0 then
        grid[x][y] = color
        return y
      end
    end
  end
  return nil
end

function displayGrid()
  local line
  for y = sizeY, 1, -1 do
    line = ""
    for x = 1, sizeX do
      local char = grid[x][y] == 1 and " X" or grid[x][y] == 0 and "  " or " O"
      line = line .. char
    end
    print(line)
  end
  line = ""
  for i = 1, sizeX do
    line = line .. " "..i
  end
  print(line)
end

while true do
  displayGrid()
  print("Your move, player "..playerColor..". Please enter a column number.")
  local x = tonumber(io.read())
  if x then
    local y = addPiece(x, playerColor)
    if y then
      if checkWin(x, y) then
        print("Player "..playerColor.." wins!")
        break
      end
      if playerColor == 1 then
        playerColor = 2
      else
        playerColor = 1
      end
    end
  end
end
