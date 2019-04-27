pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

//vectors///////////////////////////
function vec_len(x,y)
   return sqrt(x*x+y*y)
end

function vec_sub(a,b)
   return a.x-b.x,a.y-b.y
end

function vec_add(a,b)
   return a.x+b.x,a.y+b.y
end

function vec_dist(a,b)
   return vec_len(vec_sub(a,b))
end

function vec_scale(a,v)
   return a.x*v,a.y*v
end

function rot_vec(x,y,r)
   local cs = cos(r)
   local sn = sin(r)
   local nx = x * cs - y * sn
   local ny = x * sn + y * cs
   return nx,ny
end

//easing///////////////////////////
function easein(t)
   return t*t 
end
function easout(t)
   return t*(2-t) 
end

function easeinout(t) 
   return t < 0.5 and 2*t*t or -1+(4-(2*t))*t 
end

//utils////////////////////////////
function cpy(obj)
   local n = {}
   for k,v in pairs(obj) do
      n[k] = v
   end
   return n
end

function circ_col(a,b)
   return vec_dist(a,b) <= (a.r + b.r)
end

function move_obj(obj)
   if obj.grav then
      obj.dy += grav
   end
   obj.x += obj.dx
   obj.y += obj.dy
   obj.dx *= obj.rx
   obj.dy *= obj.ry
end

function col_objs(objs)
   for obj in all(objs) do
      obj.col = {}
   end
   for i=1,#objs do
      local a = objs[i]
      for j=i+1,#objs do
         local b = objs[j]
         if a.kin or b.kin then
            if circ_col(a,b) then
               add(a.cols,b)
               add(b.cols,a)
            end
         end 
      end
   end
end
//constants////////////////////////
grav = .05

objs = {}
//methods////////////////////////////
function ctrl_coin(obj)
   if btn(0) then
      obj.x -= obj.mv
   end
   if btn(1) then
      obj.x += obj.mv
   end
end   

function pig_auto_strafe(obj)
end
//prototypes///////////////////////
cam = {
   x = 64,
   y = 64
}

coin = {
   id = 'coin',
	x = 0,
   dx = 2,
   rx = .99,
	y = 64,
   dy = -1,
   ry = 1,
   r = 2,
   mv = .5,
   fys = true,
   kin = true,
   grav = true,
   act = ctrl_coin,
}

pig = {
   x = 0,
   dx = 0,
   rx = 1,
   y = 0,
   dy = 0,
   ry = 0,
   r = 4
}


//drawing////////////////////////////////////// 
function future_draw(obj, n)
   local obj_cpy = cpy(obj)
   for i=1,n do 
      move_obj(obj_cpy)
      circfill(obj_cpy.x,obj_cpy.y,.5,7)
   end
end 

function cam_coords(obj)
   local nx = (obj.x + (obj.dx * 0))
   local ny = (obj.y + (obj.dy * 0))
   return nx,ny
end

function aim_cam(cam,obj,bias)
   local nx = (cam.x*(bias-1) + obj.x) / bias 
   local ny = (cam.y*(bias-1) + obj.y) / bias
   cam.x,cam.y = nx,ny
end

function set_cam(cam)
   camera(cam.x-64,cam.y-64)
end

function dist_lines(n)
   for i=1,n do
      local c = i % 2 == 0 and 8 or 7
      line(i*16,0,i*16,128,c)
   end
end

function grid_lines(s,ox,oy)
   for i=1,flr(128/s) do
      local nx = (i*s + ox) % 128
      local ny = (i*s + oy) % 128
      line(nx,0,nx,128,7)
      line(0,ny,128,ny,6)
   end
end

//main////////////////////////////////
function _init()
   objs = {}
   add(objs,cpy(coin))
   objs.active = objs[1]
   objs.cam = cpy(cam)
end

function _update60()
   for obj in all(objs) do
      if obj.fys then
         move_obj(obj)
      end
      if obj.update then
         obj:update()
      end
   end
   objs.active:act()
end

function _draw()
   cls()
   local nx,ny = cam_coords(coin)
   //grid_lines(16,-nx,-ny) 
   //camera(nx-64,ny-64)
   //future_draw(coin,100)
   aim_cam(objs.cam,objs.active,1)
   set_cam(objs.cam)
   for obj in all(objs) do
      circfill(obj.x,obj.y,obj.r,obj.col or 7)
   end
   //camera()
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000aa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000aaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
