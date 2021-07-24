function sign(p1, p2, p3)
     return (p1[1] - p3[1]) * (p2[2] - p3[2]) - (p2[1] - p3[1]) * (p1[2] - p3[2]);
 end
  
 function check(pt, v1, v2, v3)
     local b1, b2, b3;

     b1 = button.sign(pt, v1, v2) < 0.0;
     b2 = button.sign(pt, v2, v3) < 0.0;
     b3 = button.sign(pt, v3, v1) < 0.0;

     return ((b1 == b2) and (b2 == b3));
 end
  
 function getCorners(position, size, rotation)
     local _left = Vector3(
         position.x + (size.x / 2) * math.cos(math.rad(rotation + 90)),
         position.y + (size.x / 2) * math.sin(math.rad(rotation + 90)),
         position.z
     );
     
     local _right = Vector3(
         position.x + (size.x / 2) * math.cos(math.rad(rotation - 90)),
         position.y + (size.x / 2) * math.sin(math.rad(rotation - 90)),
         position.z
     );

     local _topLeft = Vector2(
         getScreenFromWorldPosition(
             _left.x,
             _left.y,
             _left.z + size.y / 2,
             10000
         )
     );

     local _bottomLeft = Vector2(
         getScreenFromWorldPosition(
             _left.x,
             _left.y,
             _left.z - size.y / 2,
             10000
         )
     );

     local _topRight = Vector2(
         getScreenFromWorldPosition(
             _right.x,
             _right.y,
             _right.z + size.y / 2,
             10000
         )
     );

     local _bottomRight = Vector2(
         getScreenFromWorldPosition(
             _right.x,
             _right.y,
             _right.z - size.y / 2,
             10000
         )
     );

     return _topLeft, _bottomLeft, _topRight, _bottomRight;
 end 