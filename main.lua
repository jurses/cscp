function love.load()
   gr = love.graphics
   kb = love.keyboard

   per= {}
   per.dim = {x = 18, y = 18}
   per.pos = {x = 20, y = 40}
   per.sal = false
   per.vel = 600

   gravedad = 500

   suelo = {}
   suelo.dim = {x = gr.getWidth(), y = 20}
   suelo.pos = {x = 0, y = gr.getHeight() - suelo.dim.y}
end

function checaSalto()
   if per.pos.y + per.dim.y < suelo.pos.y then --comprueba que está en el aire
      return true
   end
end

function colision()
   if per.pos.y + per.dim.y >= suelo.pos.y then
      return true
   end
end

function salta()
   local dt = love.timer.getDelta()
   per.pos.y = per.pos.y - per.vel * dt
end

function rectificador()
   if per.pos.y + per.dim.y > suelo.pos.y then 
      per.pos.y = suelo.pos.y - per.dim.y
   end

   if math.abs(per.pos.y + per.dim.y - suelo.pos.y) > 0 
      and math.abs(per.pos.y + per.dim.y - suelo.pos.y) < 18 then
      per.pos.y = suelo.pos.y - per.dim.y
   end
end

function love.update(dt)
   if checaSalto() then
      per.pos.y = per.pos.y + gravedad * dt
      per.sal = true
   end

   if colision() then
      rectificador()
      per.sal = false 
   end
   
   if kb.isDown("g") and not per.sal then
      salta()
      print("puede saltar")
   end
end

function love.draw()
   gr.rectangle("line", suelo.pos.x, suelo.pos.y, suelo.dim.x, suelo.dim.y)
   gr.rectangle("fill", per.pos.x, per.pos.y, per.dim.x, per.dim.y)
   gr.print(per.pos.y, 100, 100)
   if per.sal then
      gr.print("Está saltando", 100,150)
   else
      gr.print("No está saltando", 100,150)
   end
end
