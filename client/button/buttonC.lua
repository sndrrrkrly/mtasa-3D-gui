Button = {
     rectangleColor = tocolor(30, 30, 30, 255),
     textColor = tocolor(255, 255, 255, 255),
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
          name = "onClientCursorMove"
          func = function(...),
               return Button:hover(...)
          end,
     }
};

Button:create = function(properties)
     if type(properties) ~= "table" then
		properties = {};
	end

     Button[#Button + 1] = {
          positions = properties.positions or Vector3(0, 0, 0),
          size = properties.size or Vector(1.5, 1.9),
          text = properties.text or "",
          rotation = properties.rotation or 45,
          func = properties.func or function() 
               return;
          end
     };

     for _, event in pairs(handlers) do
          removeEventHandler(event.name, root, event.func);
          addEventHandler(event.name, root, event.func);
     end
end

Button:render = function()
     if #Button == 0 then
          return;
     end
     
     for k, v in pairs(Button) do
          local positions, size, rotation, text, _ = unpack(v);

          local renderTarget = dxCreateRenderTarget(size.x * 512, size.y * 512, true);
          if not renderTarget then
               print("failed to create renderTarget");
               return;
          else
               dxSetRenderTarget(renderTarget);
          end

          dxDrawRectangle(0, 0, 200, 200, self.rectangleColor);
          dxDrawText(text, 0, 0, 200, 200, self.textColor, 4, "default", "center", "center");

          dxSetRenderTarget();
          dxDrawMaterialLine3D(
               position.x,
               position.y,
               position.z + (size.y / 2),
               position.x,
               position.y,
               position.z - (size.y / 2),
               renderTarget,
               size.x,
               tocolor(255, 255, 255, 255),
               position.x + 1 * math.cos(math.rad(rotation)),
               position.y + 1 * math.sin(math.rad(rotation)),
               position.z
          );

          destroyElement(renderTarget);
     end
end

Button:hover = function(_, _, cursorX, cursorY)
     if #Button == 0 then 
          return;
     end
     
     if isCursorShowing() then
          for k, v in pairs(Button) do
               local positions, size, rotation, _, _ = unpack(v);

               local cursorPosition = Vector2(cursorX, cursorY);
               local a, b, c, d = getCorners(position, size, rotation);

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

Button:click = function(buttonName, buttonState, cursorX, cursorY)
     if #Button == 0 then
          return;
     end

     for k, v in pairs(Button) do
          local positions, size, rotation, _, func = unpack(v);
          
          local cursorPosition = Vector2(cursorX, cursorY);
          local a, b, c, d = getCorners(position, size, rotation);

          if (check({cursorPosition.x, cursorPosition.y}, {a.x, a.y}, {b.x, b.y}, {c.x, c.y}) or check({cursorPosition.x, cursorPosition.y}, {c.x, c.y}, {d.x, d.y}, {b.x, b.y})) then
               if buttonName == "left" and buttonState == "down" then
                    func();
               end
          end
     end
end

Button:create({
     positions = Vector3(0, 0, 0),
     size = Vector(1.5, 1.9),
     text = "Teszt Gomb",
     rotation = 45,
     func = function() 
          outputChatBox("megnyomtad ezt a gombot, szuper vagy!");
     end    
});