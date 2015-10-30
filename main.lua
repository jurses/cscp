function love.load()
   gr = love.graphics
   kb = love.keyboard

   per= {}
   per.dim = {x = 18, y = 18}
   per.pos = {x = 80, y = 40}
   per.sal = false
   per.vel = 600
   per.caer = true

   gravedad = 500

   suelo = {}
   suelo.dim = {x = gr.getWidth(), y = 20}
   suelo.pos = {x = 0, y = gr.getHeight() - suelo.dim.y}

   enem = {}
   enem.lado = 20
   enem.ver = { a = {x = gr.getWidth() - enem.lado, y = suelo.pos.y},
                b = {x = gr.getWidth(), y = suelo.pos.y},
                c = {x = gr.getWidth() - enem.lado/2, y = suelo.pos.y - enem.lado}
              }
   enem.vel = 600

   juego = {}
   juego.empezar = false
end

function enemFuera(enemigo)
   if enemigo.c.x < 0 then
      table.remove(enemigo)
   end
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

function moveEnem()
   local dt = love.timer.getDelta()
   enem.ver.a.x = enem.ver.a.x - enem.vel * dt   
   enem.ver.b.x = enem.ver.b.x - enem.vel * dt   
   enem.ver.c.x = enem.ver.c.x - enem.vel * dt   
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

function love.keyreleased(key)
   if key == "g" then
      per.caer = true
   end
end

function love.update(dt)
   if per.caer then
      if checaSalto() then
         per.pos.y = per.pos.y + gravedad * dt
         per.sal = true
      end

      if colision() then
         rectificador()
         per.sal = false 
         per.caer = false
         juego.empezar = true
      end
   end
   
   if kb.isDown("g") and not per.sal and not per.caer then
      salta()
      print("puede saltar")
   end
   if juego.empezar then
      moveEnem()
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

      --ENEMIGO--
   gr.polygon('line', enem.ver.a.x, enem.ver.a.y, enem.ver.b.x, enem.ver.b.y,
                      enem.ver.c.x, enem.ver.c.y)
end
