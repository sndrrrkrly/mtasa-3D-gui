Button = {};

function Button.create(id, properties)
     if type(properties) ~= "table" then properties = {}; end
     Button[id] = properties;

     local function draw()
          local renderTarget = dxCreateRenderTarget(properties.size.x 512, properties.size.x 512, true);
          if not renderTarget then
               print("error creating renderTarget");
               return;
          end

          dxSetRenderTarget(renderTarget);
          
          dxDrawRectangle(0, 0, 250, 250, tocolor(200, 200, 200, 200));
          dxDrawText(properties.text, 0, 0, 250, 250, tocolor(255, 255, 255, 255), 4, "default", "center", "center");
     
          dxSetRenderTarget();
          dxDrawMaterialLine3D(
               properties.position.x,
               properties.position.y,
               properties.position.z + (properties.size.y / 2),
               properties.position.x,
               properties.position.y,
               properties.position.z - (properties.size.y / 2),
               renderTarget,
               properties.size.x,
               tocolor(255, 255, 255, 255),
               properties.position.x + 1 * math.cos(math.rad(properties.rotation or 45)),
               properties.position.y + 1 * math.sin(math.rad(properties.rotation or 45)),
               properties.position.z
          );

          destroyElement(renderTarget);
     end

     return draw();
end

addEventHandler("onClientPreRender", root, function()
     Button.create({
          position = Vector3(0, 0, 0),
          rotation = 45,
          size = Vector2(1.5, 1.9),
          text = "Teszt Gomb",
          func = function()
               outputChatBox("asdasdasd")
          end
     });
end);

addEventHandler("onClientKey", root, function(keyName, hasPressed)
     if keyName == "enter" and hasPressed then
          for k, v in pairs(Button) do
               print(v.text);
          end
     end
end);