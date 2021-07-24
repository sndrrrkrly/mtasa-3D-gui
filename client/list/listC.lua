List = {
     rectangleColor = tocolor(30, 30, 30, 255),
     textColor = tocolor(255, 255, 255, 255),

     activeList = false,
     selectedItem = 0,
     selectionTick = nil,

     createdLists = {},
};

setmetatable({}, {__index = List});

local screenX, screenY = guiGetScreenSize();
local handlers = {
     {
          name = "onClientPreRender",
          func = function(...)
               return List:render(...)
          end
     },
     {
          name = "onClientKey",
          func = function(...)
               return List:key(...)
          end
     }
};

function List:create(id, properties)
     if type(properties) ~= "table" then
          properties = {};
     end

     List.createdLists[id] = properties;

     for _, event in pairs(handlers) do
          removeEventHandler(event.name, root, event.func);
          addEventHandler(event.name, root, event.func);
     end
end

function List:render()
     if #List.createdLists == 0 then
          return;
     end

     for k, v in pairs(List.createdLists) do
          local renderTarget = dxCreateRenderTarget(v.size.x * 512, v.size.y * 512, true);
          if not renderTarget then
               print("failed to create renderTarget");
               return;
          else
               dxSetRenderTarget(renderTarget);
          end

          if v.name then
              dxDrawText(v.name, 110, -710, 1.5 * 512, 1.5 * 512, tocolor(255, 255, 255, 255), 6, "clear", "center", "center");
          end

          local y = 310;

          for i = 1, #v.items, 1 do
               if self.selectedItem == i then
                    local newSizeX = interpolateBetween(1.5, 0, 0, 1.6, 0, 0, (getTickCount() - self.selectionTick) / 200, 'OutQuad');
                    local newSizeY = interpolateBetween(0.3, 0, 0, 0.35, 0, 0, (getTickCount() - self.selectionTick) / 200, 'OutQuad');

                    dxDrawRectangle(50 + -20 - newSizeY - 5, y / 2, newSizeX * 512, newSizeY * 512, tocolor(0, 255, 169, 255));
                    dxDrawText(v.items[self.selectedItem].name, 50 + -20 + 45, y, newSizeX * 512, newSizeY * 512, tocolor(0, 0, 0, 255), 4, "clear", "left", "center");
               
                    y = y + 310 + 70;
               else
                    dxDrawRectangle(50, y / 2, 1.5 * 512, 0.3 * 512, self.rectangleColor);
                    dxDrawText(v.items[i].name, 50 + 45, y, 50 + 1.5 * 512, 0.3 * 512, self.textColor, 4, "clear", "left", "center");
              
                    y = y + 310;
               end
          end

          dxSetRenderTarget();
          dxDrawMaterialLine3D(
               v.positions.x,
               v.positions.y,
               v.positions.z + (v.size.y / 2),
               v.positions.x,
               v.positions.y,
               v.positions.z - (v.size.y / 2),
               renderTarget,
               v.size.x,
               tocolor(255, 255, 255, 255),
               v.positions.x + 1 * math.cos(math.rad(v.rotation)),
               v.positions.y + 1 * math.sin(math.rad(v.rotation)),
               v.positions.z
          );

          destroyElement(renderTarget);
     end
end

function List:key(keyName, hasPressed)
     if #List.createdLists == 0 or not self.activeList then
          return;
     end
     
     for k, v in pairs(List.createdLists) do
          if keyName == "arrow_u" and hasPressed then
               if self.selectedItem == 0 then
                    self.selectedItem = 1;
               end

               if self.selectedItem - 1 < 0 then
                    self.selectedItem = self.selectedItem - 1;
               else
                    self.selectedItem = 1;
               end

               self.selectionTick = getTickCount();  
          elseif keyName == "arrow_d" and hasPressed then
               if self.selectedItem == 0 then
                    self.selectedItem = 1;
               end


               if self.selectedItem + 1 < #v.items then
                    self.selectedItem = self.selectedItem + 1;
               else
                    self.selectedItem = #v.items;
               end

               self.selectionTick = getTickCount();                
          end

          if keyName == "enter" and hasPressed then
               local func = v.items[self.selectedItem].func;
               if func then 
                    func();
               end
          end
     end
end

function List:changeStatus(id, newState)
     if #List.createdLists == 0 then
          return;
     end
     
     for k, v in pairs(List.createdLists) do
          if k == id then
               self.activeList = newState;
          end
     end
end

function List:destroy(id)
     if self.createdLists[id] then
          self.createdLists[id] = {};
          return;
     end
end

function createList(...)
     return List:create(...);
end

function changeListStatus(...)
     return List:changeStatus(...);
end

function destroyList(..)
     return List:destroy(...);
end

--[[
createList(1, {
     positions = Vector3(13.50529, 3.83259, 3.10965),
     size = Vector2(2, 2),
     rotation = 75,
     name = "Haj kiválasztása",
     items = {
          [1] = {
               name = "Teszt1",
               func = function() 
                    outputChatBox("megnyomtad ezt a gombot, szuper vagy!1");
               end
          },
          
          [2] = {
               name = "Teszt2",
               func = function() 
                    outputChatBox("megnyomtad ezt a gombot, szuper vagy!2");
               end
          },

          [3] = {
               name = "Teszt3",
               func = function() 
                    outputChatBox("megnyomtad ezt a gombot, szuper vagy!3");
               end
          },

          [4] = {
               name = "Teszt4",
               func = function() 
                    outputChatBox("megnyomtad ezt a gombot, szuper vagy!4");
               end
          },
     }
});

changeListStatus(1, true);
--]]