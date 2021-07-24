Button = {
     rectangleColor = tocolor(30, 30, 30, 255),
     textColor = tocolor(255, 255, 255, 255),

     createdButtons = {},
};

setmetatable({}, {__index = Button});

local handlers = {
     {
          name = "onClientPreRender",
          func = function(...)
               return Button:render(...)
          end
     },
     {
          name = "onClientClick",
          func = function(...)
               return Button:click(...)
          end
     },
     {
          name = "onClientCursorMove",
          func = function(...)
               return Button:hover(...)
          end
     }
};

function Button:create(id, properties)
     if type(properties) ~= "table" then
		properties = {};
	end

     Button.createdButtons[id] = properties;

     for _, event in pairs(handlers) do
          removeEventHandler(event.name, root, event.func);
          addEventHandler(event.name, root, event.func);
     end
end

function Button:render()
     if #Button.createdButtons == 0 then
          return;
     end
     
     for k, v in pairs(Button.createdButtons) do
          local renderTarget = dxCreateRenderTarget(v.size.x * 512, v.size.y * 512, true);
          if not renderTarget then
               print("failed to create renderTarget");
               return;
          else
               dxSetRenderTarget(renderTarget);
          end

          dxDrawRectangle(0, 0, v.size.x * 512, v.size.y * 512, self.rectangleColor);
          dxDrawText(v.text, 0, 0, v.size.x * 512, v.size.y * 512, self.textColor, 4, "default", "center", "center");

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

function Button:hover(_, _, cursorX, cursorY)
     if #Button.createdButtons == 0 then
          return;
     end

     if isCursorShowing() then
          for k, v in pairs(Button.createdButtons) do
               local cursorPosition = Vector2(cursorX, cursorY);
               local a, b, c, d = getCorners(v.positions, v.size, v.rotation);

               if (check({cursorPosition.x, cursorPosition.y}, {a.x, a.y}, {b.x, b.y}, {c.x, c.y}) or check({cursorPosition.x, cursorPosition.y}, {c.x, c.y}, {d.x, d.y}, {b.x, b.y})) then
                    self.rectangleColor = tocolor(0, 255, 169, 255);
                    self.textColor = tocolor(0, 0, 0, 255);
               else
                    self.rectangleColor = tocolor(30, 30, 30, 255);
                    self.textColor = tocolor(255, 255, 255, 255);
               end
          end
     end
end

function Button:click(buttonName, buttonState, cursorX, cursorY)
     if #Button.createdButtons == 0 then
          return;
     end

     if isCursorShowing() then
          for k, v in pairs(Button.createdButtons) do               
               local cursorPosition = Vector2(cursorX, cursorY);
               local a, b, c, d = getCorners(v.positions, v.size, v.rotation);

               if (check({cursorPosition.x, cursorPosition.y}, {a.x, a.y}, {b.x, b.y}, {c.x, c.y}) or check({cursorPosition.x, cursorPosition.y}, {c.x, c.y}, {d.x, d.y}, {b.x, b.y})) then
                    if buttonName == "left" and buttonState == "down" then
                         v.func();
                    end
               end
          end
     end
end

function Button:destroy(id)
     if self.createdButtons[id] then
          self.createdButtons[id] = {};
          return;
     end
end

function createButton(...)
    return Button:create(...);
end

function destroyButton(..)
     return Button:destroy(...);
end

--[[
createButton(1, {
     positions = Vector3(15.10529, 3.83259, 3.10965),
     size = Vector2(1, 0.3),
     text = "Teszt Gomb2",
     rotation = 75,
     func = function() 
          outputChatBox("megnyomtad ezt a gombot, szuper vagy!");
     end  
});
--]]