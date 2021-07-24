Text = {
     textColor = tocolor(255, 255, 255, 255),

     createdTexts = {},
};

setmetatable({}, {__index = Text});

local handlers = {
     {
          name = "onClientPreRender",
          func = function(...)
               return Text:render(...)
          end
     },
};

function Text:create(id, properties)
     if type(properties) ~= "table" then
		properties = {};
	end

     Text.createdTexts[id] = properties;

     for _, event in pairs(handlers) do
          removeEventHandler(event.name, root, event.func);
          addEventHandler(event.name, root, event.func);
     end
end

function Text:render()
     if #Text.createdTexts == 0 then
          return;
     end
     
     for k, v in pairs(Text.createdTexts) do
          local renderTarget = dxCreateRenderTarget(v.size.x * 512, v.size.y * 512, true);
          if not renderTarget then
               print("failed to create renderTarget");
               return;
          else
               dxSetRenderTarget(renderTarget);
          end

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

function Text:destroy(id)
     if self.createdTexts[id] then
          self.createdTexts[id] = {};
          return;
     end
end

function createText(...)
    return Text:create(...);
end

function destroyText(..)
     return Text:destroy(...);
end

--[[

createText(1, {
     positions = Vector3(15.10529, 3.83259, 3.10965),
     size = Vector2(1, 0.3),
     text = "Teszt Gomb2",
     rotation = 75,
});

--]]