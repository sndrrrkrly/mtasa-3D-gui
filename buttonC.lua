Button = {};

local screenX, screenY = guiGetScreenSize();

function Button.create(properties)
     if type(properties) ~= "table" then
          properties = {};
     end
 
     local function draw()
          local renderTarget = dxCreateRenderTarget(screenX, 70, true);
          if not renderTarget then
               print("error creating renderTarget");
               return;
          end

          dxSetRenderTarget(renderTarget);
          
          dxDrawRectangle(0, 0, 250, 70, tocolor(200, 200, 200, 200));
          dxDrawText(properties.text, 0, 0, 250, 70, tocolor(255, 255, 255, 255), 4, "default", "center", "center");
     
          dxSetRenderTarget();
          dxDrawMaterialLine3D(
               properties.position.x,
               properties.position.y,
               properties.position.z + (properties.size. / 2),
               properties.position.x,
               properties.position.y,
               properties.position.z - (properties.size. / 2),
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
          text = "Teszt Gomb"
     });
end);