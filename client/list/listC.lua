List = {
     rectangleColor = tocolor(30, 30, 30, 255),
     textColor = tocolor(255, 255, 255, 255),

     renderTarget = nil,

     selectedItem = 1,
     selectionProgress = 0
	selectionSpeed = 4
	selectionOffset = 0.3

     createdLists = {},
};

setmetatable({}, {__index = List});

local screenX, screenY = guiGetScreenSize();
local handlers = {
     {
          name = "onClientPreRender",
          func = function(...)
               return List:reRenderSelection(...)
          end
     },
     {
          name = "onClientClick",
          func = function(...)
               return List:click(...)
          end
     },
     {
          name = "onClientCursorMove",
          func = function(...)
               return List:hover(...)
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

function List:reRenderSelection()
     if #List.createdLists == 0 then
          return;
     end
     
     for k, v in pairs(List.createdLists) do
          self.renderTarget = dxCreateRenderTarget(v.size.x * 512, v.size.y * 512, true);
          if not self.renderTarget then
               print("failed to create renderTarget");
               return;
          else
               dxSetRenderTarget(self.renderTarget);
          end

          dxDrawRectangle(0, 0, v.size.x * 512, v.size.y * 512, self.rectangleColor)
          dxDrawText(v.items[self.currentSelectedItem].name, 0, 0, v.size.x * 512, v.size.y * 512, self.textColor, 4, "default", "center", "center")
     end

     dxSetRenderTarget();
end

function List:renderSelectedItem(fadeProgress)
     if #List.createdLists == 0 then
          return;
     end
     
     for k, v in pairs(List.createdLists) do
          local position = v.positions + Vector3(0, 0, v.size.y / 2 - 0.53 - 0.28 * self.selectedItem);
          
          local rad = math.rad(v.rotation);
          local lookOffset = Vector3(math.cos(rad), math.sin(rad), 0)
          
          local animMul = math.sin(getTickCount() / 300);
          local anim = Vector3(0, 0, 0.01 * self.selectionProgress) * animMul;
          
          dxDrawMaterialLine3D(
               position + Vector3(0, 0, 0.3) + lookOffset * self.selectionOffset * self.selectionProgress + anim, 
               position + lookOffset * self.selectionOffset * self.selectionProgress + anim,
               self.renderTarget, 
               v.size.x + 0.05 * self.selectionProgress, 
               tocolor(255, 255, 255, (230 + 25 * math.sin(getTickCount() / 200)) * fadeProgress),
               position + lookOffset
          );
     end
end

function List:render()
     if #List.createdLists == 0 then
          return;
     end
     
     for k, v in pairs(List.createdLists) do
          local y = -130 + screenX / 2 + 15;

          local itemWidth = screenX;
          local itemHeight = 70;

          for i, item in ipairs(v.items) do
               if i == self.selectedItem then
                    self:renderSelectedItem(fadeProgress);
               else
                    dxDrawRectangle(0, y, itemWidth, itemHeight, self.rectangleColor)
                    dxDrawText(v.items[i].name, 0, y, itemWidth, y + itemHeight, self.textColor, 4, "default", "center", "center")
               end
               
               y = y + itemHeight;
          end

          dxSetRenderTarget();
          self:reRenderSelection();

          --dxDrawRectangle(0, 0, v.size.x * 512, v.size.y * 512, self.rectangleColor);
          --dxDrawText(v.items[self.currentSelectedItem].name, 0, 0, v.size.x * 512, v.size.y * 512, self.textColor, 4, "default", "center", "center");
     end
end

function List:key(keyName, hasPressed)
     if #List.createdLists == 0 then
          return;
     end
     
     for k, v in pairs(List.createdLists) do
          local prev = self.selectedItem;

          if keyName == "arrow_u" and hasPressed then
               self.selectedItem = self.selectedItem - 1;
               
               if self.selectedItem < 1 then
                    self.selectedItem = #v.items[self.currentSelectedItem];
               end
          elseif keyName == "arrow_d" and hasPressed then
               self.selectedItem = self.selectedItem + 1;

               if self.selectedItem > #v.items[self.currentSelectedItem] then
                    self.selectedItem = 1;
               end
          end

          if self.selectedItem ~= prev then		
               self.selectionProgress = 0.3;
          end

          if keyName == "enter" and hasPressed then
               local func = v.items[self.selectedItem].func;
               if func then func(); end
          end
     end
end

function List:getItem()
     if #List.createdLists == 0 then
          return;
     end
     
     for k, v in pairs(List.createdLists) do
	     return v.items[self.selectedItem];
     end
end

function createList(...)
     return List:create(...);
end

function getListItem(...)
     return List:getItem(...);
end

createList(1, {
     positions = Vector3(11.14115, 5.15526, 3.10965),
     size = Vector2(1, 0.3),
     rotation = 75,
     items = {
          {
               name = "Teszt1",
               func = function() 
                    outputChatBox("megnyomtad ezt a gombot, szuper vagy!1");
               end
          },
          {
               name = "Teszt2",
               func = function() 
                    outputChatBox("megnyomtad ezt a gombot, szuper vagy!2");
               end
          }
     }
});